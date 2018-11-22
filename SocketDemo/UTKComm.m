//
//  UTKComm.m
//  SocketDemo
//
//  Created by UTEAMTEC on 2018/11/21.
//  Copyright © 2018年 UTEAMTEC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UTKComm.h"
#import <arpa/inet.h>
#import <unistd.h>
#include <sys/fcntl.h>

@implementation UTKComm
@synthesize state;
@synthesize ip;
@synthesize port;
@synthesize buff;
@synthesize buffIdx;
@synthesize socket;

@synthesize runloopSource;
@synthesize delegate;

-(instancetype) initWithIp:(NSString*)ip port:(int)port {
    if (self = [super init]) {
        self.ip = ip;
        self.port = port;
        _lock = [[NSLock alloc] init];
        buff = malloc(sizeof(unsigned char*)*3);
        for (int m = 0; m < 3; m ++) {
            buff[m] = malloc(sizeof(unsigned char)*1024);
        }
        buffIdx = 0;
        state = SKT_STATE_DISCONNECT;
    }
    return self;
}

- (void)dealloc
{
    for (int m = 0; m < 3; m ++) {
        free(buff[m]);
    }
}

-(void) connect {
    if (state == SKT_STATE_CONNECTTING) {
        return;
    }
    else if (state == SKT_STATE_CONNECTED) {
        NSLog(@"disconnect previous connection");
        [self disconnect];
    }
    
    _ctx.info = (__bridge void*) self;
    _ctx.version = 0;
    _ctx.retain = NULL;
    _ctx.release = NULL;
    _ctx.copyDescription = NULL;
    
    socket = CFSocketCreate(kCFAllocatorDefault, AF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketConnectCallBack|kCFSocketDataCallBack|kCFSocketWriteCallBack, (CFSocketCallBack)SktCallback, &_ctx);
    assert(CFSocketIsValid(socket));
    
    struct sockaddr_in sock_addr;
    memset(&sock_addr, 0, sizeof(sock_addr));
    sock_addr.sin_len=sizeof(sock_addr);
    sock_addr.sin_family = AF_INET;
    sock_addr.sin_port = htons(self.port);
    if(inet_pton(AF_INET, [ip UTF8String], (void*)&sock_addr.sin_addr)<= 0){
        return;
    }
    
    
    CFDataRef dataRef =  CFDataCreate(kCFAllocatorDefault, (UInt8*) &sock_addr, sizeof(sock_addr));
    CFSocketConnectToAddress(socket, dataRef, 10);
    CFRelease(dataRef);
    
    runloopSource = CFSocketCreateRunLoopSource(kCFAllocatorDefault, socket, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runloopSource, kCFRunLoopCommonModes);
    
    state = SKT_STATE_CONNECTTING;
    if (delegate) {
        [delegate onStateChanged:SKT_STATE_CONNECTTING];
    }
    
}
-(void) disconnect {
    //remove runloopsource
    if (runloopSource) {
        CFRunLoopRef runloop = CFRunLoopGetCurrent();
        if (CFRunLoopContainsSource(runloop, runloopSource, kCFRunLoopDefaultMode)) {
            CFRunLoopRemoveSource(runloop, runloopSource, kCFRunLoopDefaultMode);
            CFRelease(runloopSource);
        }
    }
    
    //close socket
    if (socket) {
        if (CFSocketIsValid(socket)){
            CFSocketInvalidate(socket);
        }
        CFRelease(socket);
    }
    
    state = SKT_STATE_DISCONNECT;
    if (delegate) {
        [delegate onStateChanged:SKT_STATE_DISCONNECT];
    }

}

-(long) recv {
    unsigned char* bf = malloc(sizeof(unsigned char)*1024);
    long res = recv(CFSocketGetNative(socket), bf, sizeof(unsigned char)*1024, 0);
    
    if (res == -1){
        NSLog(@"socket broken while reading, errno=%d", errno);
        [self onDisconnect];
        free(bf);
        return res;
    }
    NSLog(@"received data len = %ld, content = %d", res, bf[1]);
    free(bf);
    if (res > 0 && delegate) {
        [delegate onDataReceived:buff[buffIdx] length: (int)res];
    }
    buffIdx ++;
    if (buffIdx >= 3) {
        buffIdx = 0;
    }
    return res;
}
-(long) send:(unsigned char*)buff length:(int)len {
    long res = send(CFSocketGetNative(socket), buff, sizeof(unsigned char)*len, 0);
    if (res == -1) {
        NSLog(@"socket broken while sending, errno=%d", errno);
        [self onDisconnect];
    }
    if (res > 0 && delegate) {
        [delegate onDataSent:(int) res];
    }
    return res;
}

-(void) onDisconnect {
    [self disconnect];
}

void SktCallback(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info){
    UTKComm *tcpComm = (__bridge UTKComm*) info;
    long res = 0;
    unsigned char buff[8];
    switch (type) {
        case kCFSocketConnectCallBack:
            if (data == NULL) {
                NSLog(@"connect succeed");
                tcpComm.state = SKT_STATE_CONNECTED;
                
                if (tcpComm.delegate) {
                    [tcpComm.delegate onStateChanged:SKT_STATE_CONNECTED];
                }
            }
            else {
                NSLog(@"connect failed errno=%d", *(UInt32*)data);
            }
            break;
        case kCFSocketAcceptCallBack:
            break;
        case kCFSocketDataCallBack:
            
            res = [tcpComm recv];
            NSLog(@"incoming data received %ld", res);
            buff[0] = 0x00;
            buff[1] = 0xAA;
            buff[2] = 0x00;
            buff[3] = 0xCC;
            buff[4] = 231;
            res = [tcpComm send:buff length:4];
            NSLog(@"incoming data sent %ld", res);
            break;
        case kCFSocketWriteCallBack:
            break;
        default:
            NSLog(@"unregistered event");
            break;
    }
}
@end

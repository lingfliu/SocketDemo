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

@implementation UTKComm
@synthesize buff;
@synthesize socket;
@synthesize ip;
@synthesize port;
@synthesize runloop;
@synthesize runloopSource;

-(instancetype) initWithIp:(NSString*)ip port:(int)port {
    if (self = [super init]) {
        self.ip = ip;
        self.port = port;
        buff = malloc(sizeof(unsigned char)*1024);
    }
    return self;
}

- (void)dealloc
{
    free(buff);
}

-(void) connect {
    _ctx.info = (__bridge void*) self;
    _ctx.version = 0;
    _ctx.retain = NULL;
    _ctx.release = NULL;
    _ctx.copyDescription = NULL;
    
    socket = CFSocketCreate(kCFAllocatorDefault, AF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketConnectCallBack|kCFSocketDataCallBack, (CFSocketCallBack)SktCallback, &_ctx);
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

}

-(long) recv:(unsigned char*)buff length:(int)len {
    long res = recv(CFSocketGetNative(self.socket), buff, sizeof(unsigned char)*1024, 0);
    if (res < 0){
        NSLog(@"socket broken, errno=", errno);
        [self onDisconnect];
    }
    return res;
}
-(long) send:(unsigned char*)buff length:(int)len {
    long res = send(CFSocketGetNative(socket), buff, sizeof(unsigned char), len);
    if (res < 0) {
        NSLog(@"socket broken, errno=", errno);
        [self onDisconnect];
    }
    return res;
}

-(void) onDisconnect {
    [self disconnect];
}

void SktCallback(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info){
//    UTKComm *tcpComm = (__bridge UTKComm*) info;
    switch (type) {
        case kCFSocketConnectCallBack:
            if (data == NULL) {
                NSLog(@"connect succeed");
            }
            else {
                NSLog(@"connect failed errno=%d", *(UInt32*)data);
            }
            break;
        case kCFSocketAcceptCallBack:
            NSLog(@"accept callback");
            break;
        case kCFSocketDataCallBack:
            NSLog(@"incoming data");
            unsigned char buff[1024];
            long res = recv(CFSocketGetNative(s), buff, sizeof(buff[0])*4, 0);
//            long res = [tcpComm recv:tcpComm.buff length:1024];
            if (res > 0) {
                send(CFSocketGetNative(s), buff, sizeof(buff[0]*res), 0);
//                [tcpComm send:tcpComm.buff length:res];
            }
            break;
        case kCFSocketWriteCallBack:
            NSLog(@"sent data");
            break;
        default:
            NSLog(@"unregistered event");
            break;
    }
}
@end

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

@synthesize socket;
@synthesize ip;
@synthesize port;

-(instancetype) initWithIp:(NSString*)ip port:(int)port {
    if (self = [super init]) {
        self.ip = ip;
        self.port = port;
    }
    return self;
}

-(void) connect {
    CFSocketContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    socket = CFSocketCreate(kCFAllocatorDefault, AF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketConnectCallBack|kCFSocketDataCallBack, (CFSocketCallBack)SktCallback, &context);
    struct sockaddr_in sock_addr;
    memset(&sock_addr, 0, sizeof(sock_addr));
    sock_addr.sin_len=sizeof(sock_addr);
    sock_addr.sin_family = AF_INET;
    sock_addr.sin_port = htons(self.port);
    if(inet_pton(AF_INET, [ip UTF8String], (void*)&sock_addr.sin_addr)<= 0){
        return;
    }
    CFDataRef dataRef =  CFDataCreate(kCFAllocatorDefault, (UInt8*) &sock_addr, sizeof(sock_addr));
    CFSocketConnectToAddress(socket, dataRef, -1);
    
}
-(void) disconnect {
    
}
-(int) recv:(unsigned char*)buff length:(int)len {
    return 0;
}
-(int) send:(unsigned char*)buff length:(int)len {
    return 0;
}

void SktCallback(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info){
    UTKComm *tcpComm = (__bridge UTKComm*) info;
    switch (type) {
        case kCFSocketConnectCallBack:
            if (data == NULL) {
//                tcpComm.state = TCP_STATE_CONNECTED;
//                [tcpComm startReceive];
                NSLog(@"connect succeed");
            }
            else {
//                tcpComm.state = TCP_STATE_DISCONNECT;
                NSLog(@"connect failed errno=%d", *(UInt32*)data);
//                [tcpComm onDisconnect];
            }
            
//            if (tcpComm.delegate) {
//                [tcpComm.delegate onTcpStateChanged:tcpComm.state];
//            }
            break;
        case kCFSocketAcceptCallBack:
            NSLog(@"accept callback");
            break;
        case kCFSocketDataCallBack:
            NSLog(@"incoming data");
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

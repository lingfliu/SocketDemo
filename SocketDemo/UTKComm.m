//
//  UTKComm.m
//  SocketDemo
//
//  Created by UTEAMTEC on 2018/11/21.
//  Copyright © 2018年 UTEAMTEC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UTKComm.h"

@implementation UTKComm

@synthesize socket;
@synthesize ip;
@synthesize port;

-(instancetype) initWithIp:(NSString*)ip port:(int)port {
    self.ip = ip;
    self.port = port;
}
-(void) connect {
    
    socket = CFSocketCreate(kCFAllocatorDefault, AF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketConnectCallBack|kCFSocketDataCallBack, <#CFSocketCallBack callout#>, <#const CFSocketContext *context#>)
}
-(void) disconnect {
    
}
-(int) recv:(unsigned char*)buff length:(int)len {
    
}
-(int) send:(unsigned char*)buff length:(int)len {
    
}


@end

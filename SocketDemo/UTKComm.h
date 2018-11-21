//
//  UTKComm.h
//  SocketDemo
//
//  Created by UTEAMTEC on 2018/11/21.
//  Copyright © 2018年 UTEAMTEC. All rights reserved.
//

#ifndef UTKComm_h
#define UTKComm_h
#import <CoreFoundation/CoreFoundation.h>
#include <sys/socket.h>
#include <netinet/in.h>


@interface UTKComm:NSObject
@property unsigned char *buff;
@property CFSocketRef socket;
@property CFRunLoopRef runloop;
@property CFRunLoopSourceRef runloopSource;
@property CFSocketContext ctx;
@property NSString *ip;
@property int port;

-(instancetype) initWithIp:(NSString*)ip port:(int)port;
-(void) connect;
-(void) disconnect;
-(long) recv:(unsigned char*)buff length:(int)len;
-(long) send:(unsigned char*)buff length:(int)len;

-(void) onDisconnect;
@end
#endif /* UTKComm_h */

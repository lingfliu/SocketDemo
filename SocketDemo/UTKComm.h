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

static const int SKT_STATE_DISCONNECT = 1;
static const int SKT_STATE_CONNECTTING = 2;
static const int SKT_STATE_CONNECTED = 3;

@protocol UTKCommDelegate
@required -(void) onStateChanged:(int) state;
@required -(void) onDataReceived:(unsigned char*) buff length:(int)len;
@optional -(void) onDataSent:(int)len;
@end

@interface UTKComm:NSObject
@property int state;
@property unsigned char **buff;
@property int buffIdx;
@property CFSocketRef socket;
@property CFRunLoopRef runloop;
@property CFRunLoopSourceRef runloopSource;
@property CFSocketContext ctx;
@property NSString *ip;
@property int port;
@property NSLock *lock;
@property id<UTKCommDelegate> delegate;

-(instancetype) initWithIp:(NSString*)ip port:(int)port;
-(void) connect;
-(void) disconnect;
-(long) recv;
-(long) send:(unsigned char*)buff length:(int)len;

-(void) onDisconnect;
@end
#endif /* UTKComm_h */

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
@property CFSocketRef socket;
@property NSString *ip;
@property int port;

-(instancetype) initWithIp:(NSString*)ip port:(int)port;
-(void) connect;
-(void) disconnect;
-(int) recv:(unsigned char*)buff length:(int)len;
-(int) send:(unsigned char*)buff length:(int)len;

@end
#endif /* UTKComm_h */

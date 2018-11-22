//
//  ViewController.m
//  SocketDemo
//
//  Created by UTEAMTEC on 2018/11/21.
//  Copyright © 2018年 UTEAMTEC. All rights reserved.
//

#import "ViewController.h"
#import "UTKComm.h"
#import "GCDAsyncSocket.h"
#import "UTKCyclicThread.h"

@interface ViewController () <GCDAsyncSocketDelegate>
@property(strong, atomic) GCDAsyncSocket *socket;
@property NSData *buff;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
//    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
//    NSString *initStr = @"11111111111111111111111111111111";
//    _buff = [[NSData alloc] initWithData:[initStr dataUsingEncoding:NSUTF8StringEncoding]];
//    NSError *err = nil;
//    if (![_socket connectToHost:@"127.0.0.1" onPort:9003 error:&err]){
//        NSLog(@"connection failed %@", err);
//    }
//
//    [_socket writeData:[@"hello" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:1];

    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - GCDAsyncSocketDelegate

-(void) socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"connection succeed");
    
//    [_socket readDataToData:_buff withTimeout:-1 maxLength:32 tag:1];
//    [_socket readDataToLength:1 withTimeout:-1 tag:1];
}

-(void) socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"connection failed");
}

-(void) socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"received data content = %@", text);
    
//    [_socket readDataToData:_buff withTimeout:-1 maxLength:32 tag:1];
//    [sock readDataToLength:1 withTimeout:-1 tag:1];
}

-(void) socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"data sent, tag = %ld", tag);
    NSString *str = @"hello";
    [sock writeData: [str dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:1];
}
@end


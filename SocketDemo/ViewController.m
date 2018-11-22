//
//  ViewController.m
//  SocketDemo
//
//  Created by UTEAMTEC on 2018/11/21.
//  Copyright © 2018年 UTEAMTEC. All rights reserved.
//

#import "ViewController.h"
#import "UTKComm.h"
UTKComm *comm;
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    comm = [[UTKComm alloc] initWithIp:@"127.0.0.1" port:9003];
    [comm connect];
    // Do any additional setup after loading the view, typically from a nib.
}


@end

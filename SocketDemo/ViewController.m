//
//  ViewController.m
//  SocketDemo
//
//  Created by UTEAMTEC on 2018/11/21.
//  Copyright © 2018年 UTEAMTEC. All rights reserved.
//

#import "ViewController.h"
#import "UTKComm.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UTKComm *comm = [UTKComm initWithIp:@"192.168.0.100" port:9002];
    [comm connect];
    // Do any additional setup after loading the view, typically from a nib.
}


@end

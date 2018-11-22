//
//  UTKCyclicThread.m
//  heartcool
//
//  Created by lingfliu on 2017/12/1.
//  Copyright © 2017年 uteamtec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UTKCyclicThread.h"

@implementation UTKCyclicThread
@synthesize context;

- (id) init {
    if (self = [super init]) {
        isRunning = YES;
    }
    return self;
}

- (id) initWithContext:(NSObject*) context {
    if(self = [super init]) {
        self.context = context;
        isRunning = YES;
    }
    
    return self;
}

- (void) start {
    if (!thread) {
        thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:nil];
    }

    [thread start];
}

- (void) run:(NSString *)str {
    while (1) {
        if (!isRunning) {
            break;
        }
        [self work];
    }
}

-  (void) work {
    [self doesNotRecognizeSelector:_cmd];
}

- (void) quit {
    isRunning = NO;
}

- (void) dealloc {
    self.context = nil;
}
@end

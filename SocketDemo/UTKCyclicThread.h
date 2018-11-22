//
//  UTKCyclicThread.h
//  heartcool
//
//  Created by lingfliu on 2017/12/1.
//  Copyright © 2017年 uteamtec. All rights reserved.
//

#ifndef UTKCyclicThread_h
#define UTKCyclicThread_h

@interface UTKCyclicThread:NSObject

{
@private
    BOOL isRunning;
    NSThread * thread;
}
@property(nonatomic, weak) NSObject* context;
- (id) initWithContext:(NSObject*) context;
- (void) start;
- (void) quit;
- (void) work;
@end

#endif /* UTKCyclicThread_h */

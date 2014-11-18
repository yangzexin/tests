//
//  main.m
//  GCD
//
//  Created by yangzexin on 11/18/14.
//  Copyright (c) 2014 sf-express. All rights reserved.
//

#import <Foundation/Foundation.h>

void test_dispatch_group()
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"b1");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"b2");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"b3");
    });
    dispatch_group_notify(group, queue, ^{
        // 当group里面的所有block执行完毕，当前回调会得到通知
        NSLog(@"group finished");
    });
}

void test_dispatch_barrier()
{
    dispatch_queue_t queue = dispatch_queue_create("test_dispatch_barrier", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:.20f];
        NSLog(@"b1");
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:.20f];
        NSLog(@"b2");
    });
    dispatch_barrier_async(queue, ^{
        [NSThread sleepForTimeInterval:.50f];
        NSLog(@"barrier_async");
    });
    dispatch_async(queue, ^{
        NSLog(@"b3");
    });
}

void test_dispatch_apply()
{
    dispatch_apply(10, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
        NSLog(@"%ld", index);
    });
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //test_dispatch_group();
        //test_dispatch_barrier();
        test_dispatch_apply();
        
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
    }
    return 0;
}

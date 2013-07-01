//
//  main.m
//  OperationPoolTest
//
//  Created by yangzexin on 13-7-1.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSBlockedOperation.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        NSOperationQueue *operationQueue = [NSOperationQueue new];
        [operationQueue setMaxConcurrentOperationCount:2];
        for(NSInteger i = 0; i < 100; ++i){
            [operationQueue addOperationWithBlock:^{
                NSLog(@"sending:%ld", i);
                NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
                [NSThread sleepForTimeInterval:arc4random() % 10];
                NSLog(@"finish:%ld, cost:%f", i, [NSDate timeIntervalSinceReferenceDate] - startTime);
            }];
        }
        [NSThread sleepUntilDate:[NSDate distantFuture]];
    }
    return 0;
}


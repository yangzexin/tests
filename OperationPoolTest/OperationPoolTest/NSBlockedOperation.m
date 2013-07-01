//
//  NSBlockedOperation.m
//  OperationPoolTest
//
//  Created by yangzexin on 13-7-1.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "NSBlockedOperation.h"

@implementation NSBlockedOperation

- (void)main
{
    if(self.mainHandler){
        self.mainHandler();
    }
}

+ (id)blockedOperationWithMainHandler:(void(^)())mainHandler
{
    NSBlockedOperation *operation = [NSBlockedOperation new];
    operation.mainHandler = mainHandler;
    
    return operation;
}

@end

//
//  NSBlockedOperation.h
//  OperationPoolTest
//
//  Created by yangzexin on 13-7-1.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBlockedOperation : NSOperation

@property(nonatomic, copy)void(^mainHandler)();

+ (id)blockedOperationWithMainHandler:(void(^)())mainHandler;

@end

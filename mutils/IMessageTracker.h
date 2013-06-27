//
//  IMessageTracker.h
//  mtracker
//
//  Created by yangzexin on 13-6-24.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMessageTracker : NSObject

+ (BOOL)isIMessageSentWithNumber:(NSString *)number date:(NSTimeInterval)date error:(NSError **)error;

@end

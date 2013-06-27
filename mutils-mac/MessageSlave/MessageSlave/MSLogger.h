//
//  MSLogger.h
//  MessageSlave
//
//  Created by yangzexin on 4/12/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSLogger : NSObject

@property(nonatomic, copy)void(^logHandler)(NSString *log);

+ (id)defaultLogger;
- (void)log:(NSString *)log;

@end

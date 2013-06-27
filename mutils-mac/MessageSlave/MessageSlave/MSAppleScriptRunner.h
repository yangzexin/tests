//
//  MSAppleScriptRunner.h
//  MessageSlave
//
//  Created by yangzexin on 13-4-12.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSAppleScriptRunner : NSObject

- (id)initWithScript:(NSString *)script;
- (void)runAsync;
- (void)runSync;
- (void)stop;

@end

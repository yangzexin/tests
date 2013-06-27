//
//  MSAsyncScriptMessageSender.h
//  MessageSlave
//
//  Created by yangzexin on 4/15/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSMessage;

@interface MSAsyncScriptMessageSender : NSObject

- (id)initWithScript:(NSString *)script;
- (BOOL)sendMessage:(MSMessage *)message;
- (void)cancel;

@end

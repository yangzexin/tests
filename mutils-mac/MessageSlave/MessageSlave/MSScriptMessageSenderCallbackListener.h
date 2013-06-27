//
//  MSScriptMessageSenderCallbackListener.h
//  MessageSlave
//
//  Created by yangzexin on 13-4-12.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSMessage;

@interface MSScriptMessageSenderCallbackListener : NSObject

@property(nonatomic, assign)NSTimeInterval timeOutInterval;

- (id)initWithMessage:(MSMessage *)message;
- (BOOL)listenUtilMessageDidSend;

@end

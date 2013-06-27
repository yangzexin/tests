//
//  MSAsyncMessageSender.h
//  MessageSlave
//
//  Created by yangzexin on 13-4-16.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSMessage;

@interface MSAsyncMessageSender : NSObject

@property(nonatomic, assign)BOOL isLastFailed;
- (id)initWithScript:(NSString *)sendMessageScript;
- (void)sendMessage:(MSMessage *)msg completionHandler:(void(^)(MSMessage *message, BOOL succeed))completionHandler;
- (void)cancel;

@end

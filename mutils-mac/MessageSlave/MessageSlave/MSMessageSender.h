//
//  MessageSender.h
//  MessageSlave
//
//  Created by yangzexin on 13-4-11.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

OBJC_EXPORT NSString *kMessageDidSendCallbackNotification;

@class MSAppleID;
@class MSMessage;

@protocol MSMessageSender <NSObject>

- (void)checkLoginWithAppleId:(MSAppleID *)appleId;
- (void)logout;
- (BOOL)sendMessage:(MSMessage *)message;

@end

//
//  MSMessageSendQueue.h
//  MessageSlave
//
//  Created by yangzexin on 13-4-11.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSAppleID;
@class MSMessage;
@protocol MSMessageSender;
@protocol MSMessageDAO;

@interface MSMessagePreemptiveSender : NSObject

@property(nonatomic, copy)void(^messageFinishHandler)(MSMessage *message, BOOL success);
@property(nonatomic, copy)MSMessage *(^messageForSendBlock)();

- (id)initWithMesssageSender:(id<MSMessageSender>)messageSender;
- (void)start;
- (void)cancel;

@end

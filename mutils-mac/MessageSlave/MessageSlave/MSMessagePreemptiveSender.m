//
//  MSMessageSendQueue.m
//  MessageSlave
//
//  Created by yangzexin on 13-4-11.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "MSMessagePreemptiveSender.h"
#import "MSMessageDAO.h"
#import "MSMessageSender.h"
#import "MSAppleID.h"
#import "MSMessage.h"

@interface MSMessagePreemptiveSender ()

@property(nonatomic, retain)id<MSMessageSender> messageSender;
@property(nonatomic, assign)BOOL isRunning;
@property(nonatomic, assign)BOOL isCanceled;

@end

@implementation MSMessagePreemptiveSender

- (void)dealloc
{
    [self cancel];
    self.messageFinishHandler = nil;
    self.messageForSendBlock = nil;
    self.messageSender = nil;
    [super dealloc];
}

- (id)initWithMesssageSender:(id<MSMessageSender>)messageSender
{
    self = [super init];
    
    self.messageSender = messageSender;
    
    return self;
}

- (void)start
{
    if(self.isRunning || self.isCanceled){
        return;
    }
    self.isRunning = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while(!self.isCanceled){
            MSMessage *msg = self.messageForSendBlock();
            if(msg){
                MSLog(@"____preemptive send start");
                BOOL success = [self.messageSender sendMessage:msg];
                MSLog(@"____preemptive send end");
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if(self.messageFinishHandler){
                        self.messageFinishHandler(msg, success);
                    }
                });
            }
        }
        MSLog(@"preemptive sender stoped");
        self.isRunning = NO;
    });
}

- (void)cancel
{
    self.messageFinishHandler = nil;
    self.isCanceled = YES;
}

@end

//
//  MSScriptMessageSenderCallbackListener.m
//  MessageSlave
//
//  Created by yangzexin on 13-4-12.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "MSScriptMessageSenderCallbackListener.h"
#import "MSMessageSender.h"
#import "MSMessage.h"

@interface MSScriptMessageSenderCallbackListener ()

@property(nonatomic, retain)MSMessage *message;
@property(nonatomic, assign)NSTimeInterval startTime;
@property(nonatomic, assign)BOOL isWaiting;
@property(nonatomic, assign)BOOL timeOut;

@end

@implementation MSScriptMessageSenderCallbackListener

- (void)dealloc
{
    self.message = nil;
    [super dealloc];
}

- (id)initWithMessage:(MSMessage *)message
{
    self = [super init];
    
    self.message = message;
    self.timeOutInterval = 12.0f;
    [self reset];
    
    return self;
}

- (void)reset
{
    self.timeOut = NO;
    self.isWaiting = NO;
}

- (BOOL)listenUtilMessageDidSend
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageDidSendCallbackNotification:) name:kMessageDidSendCallbackNotification object:nil];
    self.isWaiting = YES;
    self.startTime = [NSDate timeIntervalSinceReferenceDate];
    [NSThread detachNewThreadSelector:@selector(checkTimeOutMain) toTarget:self withObject:nil];
    while(self.isWaiting){
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    BOOL timeOut = self.timeOut;
    [self reset];
    return !timeOut;
}

- (void)checkTimeOutMain
{
    @autoreleasepool{
        while(YES){
            [NSThread sleepForTimeInterval:0.10f];
            if([NSDate timeIntervalSinceReferenceDate] - self.startTime > self.timeOutInterval){
                self.timeOut = YES;
                self.isWaiting = NO;
                break;
            }
        }
        if([NSThread currentThread] != [NSThread mainThread]){
            [NSThread exit];
        }
    }
}

- (void)messageDidSendCallbackNotification:(NSNotification *)n
{
    NSString *number = n.object;
    if([number isEqualToString:self.message.destination]){
        self.isWaiting = NO;
    }
}

@end

//
//  MSAsyncScriptMessageSender.m
//  MessageSlave
//
//  Created by yangzexin on 4/15/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import "MSAsyncScriptMessageSender.h"
#import "MSAppleScriptRunner.h"
#import "MSMessage.h"
#import "MSScriptMessageSenderCallbackListener.h"
#import "MSCommon.h"

@interface MSAsyncScriptMessageSender ()

@property(nonatomic, copy)NSString *sendMessageScripts;
@property(nonatomic, retain)MSAppleScriptRunner *sendMsgScriptRunner;

@end

@implementation MSAsyncScriptMessageSender

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.sendMsgScriptRunner stop]; self.sendMsgScriptRunner = nil;
    self.sendMessageScripts = nil;
    [super dealloc];
}

- (id)initWithScript:(NSString *)script
{
    self = [super init];
    
    self.sendMessageScripts = script;
    
    return self;
}

- (NSString *)filterScriptVariable:(NSString *)variable
{
    return [variable stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
}

- (BOOL)sendMessage:(MSMessage *)message
{
    MSLog(@"sending msg to:%@ \tcontent:%@", message.destination, message.content);
    MSScriptMessageSenderCallbackListener *callbackListener = [[[MSScriptMessageSenderCallbackListener alloc] initWithMessage:message] autorelease];
//    callbackListener.timeOutInterval = 5.0f;
//    [NSThread sleepForTimeInterval:2.0f];
    NSString *script = self.sendMessageScripts;
    script = [script stringByReplacingOccurrencesOfString:@"$destination" withString:[self filterScriptVariable:message.destination]];
    script = [script stringByReplacingOccurrencesOfString:@"$messageContent" withString:[self filterScriptVariable:message.content]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            MSLog(@"add console observer");
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(consoleDidStopSendNotification:) name:kConsoleDidStopSendMessageNotification object:nil];
        });
        [self.sendMsgScriptRunner stop];
        self.sendMsgScriptRunner = [[[MSAppleScriptRunner alloc] initWithScript:script] autorelease];
        [self.sendMsgScriptRunner runSync];
        dispatch_sync(dispatch_get_main_queue(), ^{
            MSLog(@"remove console stop observer");
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        });
        
//        [self runAppleScript:script];

//        [NSThread sleepForTimeInterval:2.0f];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"kMessageDidSendCallbackNotification" object:@"+8618607072318"];
    });
    BOOL success = [callbackListener listenUtilMessageDidSend];
    MSLog(@"send %@", success ? @"success" : @"fail");
//    if(success){
//        [self.sendMsgScriptRunner stop];
//    }
    return success;
}

- (void)consoleDidStopSendNotification:(NSNotification *)n
{
    MSLog(@"consoleDidStopSendNotification:%@", n);
    [self.sendMsgScriptRunner stop];
    self.sendMsgScriptRunner = nil;
}

- (void)cancel
{
    [self.sendMsgScriptRunner stop];
    self.sendMsgScriptRunner = nil;
}

@end

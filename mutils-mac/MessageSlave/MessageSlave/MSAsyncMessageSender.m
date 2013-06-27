//
//  MSAsyncMessageSender.m
//  MessageSlave
//
//  Created by yangzexin on 13-4-16.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "MSAsyncMessageSender.h"
#import "MSScriptMessageSender.h"
#import "MSMessage.h"

@interface MSAsyncMessageSender ()

@property(nonatomic, copy)NSString *sendMessageScript;
@property(nonatomic, copy)void(^completionHandler)(MSMessage *message, BOOL succeed);
@property(nonatomic, retain)MSMessage *message;
@property(nonatomic, assign)BOOL isFinished;

@end

@implementation MSAsyncMessageSender

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.sendMessageScript = nil;
    self.completionHandler = nil;
    self.message = nil;
    [super dealloc];
}

- (id)initWithScript:(NSString *)sendMessageScript
{
    self = [super init];
    
    self.sendMessageScript = sendMessageScript;
    
    return self;
}

- (void)runAppleScript:(NSString *)script
{
//    MSLog(@"run script:\n%@", script);
    NSAppleScript *appleScript = [[[NSAppleScript alloc] initWithSource:script] autorelease];
    
    NSDictionary *compileError = nil;
    [appleScript compileAndReturnError:&compileError];
    MSLog(@"script compile error:%@", compileError);
    
    NSDictionary *executeError = nil;
    [appleScript executeAndReturnError:&executeError];
    MSLog(@"script execute error:%@", executeError);
}

- (NSString *)filterScriptVariable:(NSString *)variable
{
    variable = [variable stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    variable = [variable stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
    NSDictionary *replacements = @{@"\"" : @"\\\"", @"\n" : @"\\n", @"\r" : @"\\r"};
    for(NSString *key in [replacements allKeys]){
        variable = [variable stringByReplacingOccurrencesOfString:key withString:[replacements objectForKey:key]];
    }
    return variable;
}

- (void)sendMessage:(MSMessage *)message completionHandler:(void(^)(MSMessage *message, BOOL succeed))completionHandler
{
    self.message = message;
    self.completionHandler = completionHandler;
    MSLog(@"(%@)sending message to %@", self, message.destination);
    NSString *script = self.sendMessageScript;
    script = [script stringByReplacingOccurrencesOfString:@"$destination" withString:[self filterScriptVariable:message.destination]];
    script = [script stringByReplacingOccurrencesOfString:@"$messageContent" withString:[self filterScriptVariable:message.content]];
    if(self.isLastFailed){
        script = [script stringByReplacingOccurrencesOfString:@"$returnKey" withString:@"key down return"];
    }else{
        script = [script stringByReplacingOccurrencesOfString:@"$returnKey" withString:@""];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageDidSendCallbackNotification:) name:kMessageDidSendCallbackNotification object:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self runAppleScript:script];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:7.0f];
        if(!self.isFinished){
            self.isFinished = YES;
            self.isLastFailed = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                if(self.completionHandler){
                    MSLog(@"Time out");
                    self.completionHandler(self.message, NO);
                }
            });
        }
    });
}

- (void)cancel
{
    self.completionHandler = nil;
}

- (void)messageDidSendCallbackNotification:(NSNotification *)n
{
    NSString *number = n.object;
    if([number isEqualToString:self.message.destination]){
        self.isFinished = YES;
        self.isLastFailed = NO;
        MSLog(@"success:%@", self.message.destination);
        if(self.completionHandler){
            self.completionHandler(self.message, YES);
        }
    }
}

@end

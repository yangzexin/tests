//
//  MSScriptMessageSender.m
//  MessageSlave
//
//  Created by yangzexin on 13-4-11.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "MSScriptMessageSender.h"
#import "MSAppleID.h"
#import "MSMessage.h"
#import "MSScriptMessageSenderCallbackListener.h"
#import "MSAppleScriptRunner.h"
#import "MSCommon.h"
#import "MSAsyncScriptMessageSender.h"

@interface MSScriptMessageSender ()

@property(nonatomic, copy)NSString *checkLoginScripts;
@property(nonatomic, copy)NSString *logoutScripts;
@property(nonatomic, copy)NSString *sendMessageScripts;

@end

@implementation MSScriptMessageSender

- (void)dealloc
{
    self.checkLoginScripts = nil;
    self.logoutScripts = nil;
    self.sendMessageScripts = nil;
    [super dealloc];
}

- (id)initWithCheckLoginScripts:(NSString *)checkLoginScripts logoutScripts:(NSString *)logoutScripts sendMessageScripts:(NSString *)sendMessageScripts
{
    self = [super init];
    
    self.checkLoginScripts = checkLoginScripts;
    self.logoutScripts = logoutScripts;
    self.sendMessageScripts = sendMessageScripts;
    
    return self;
}

- (NSString *)filterScriptVariable:(NSString *)variable
{
    return [variable stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
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

- (void)checkLoginWithAppleId:(MSAppleID *)appleId
{
    MSLog(@"start check login");
//    [NSThread sleepForTimeInterval:2.0f];
    NSString *script = self.checkLoginScripts;
    script = [script stringByReplacingOccurrencesOfString:@"$appleID" withString:[self filterScriptVariable:appleId.appldID]];
    script = [script stringByReplacingOccurrencesOfString:@"$password" withString:[self filterScriptVariable:appleId.password]];
    MSLog(@"checking");
    [self runAppleScript:script];
    [NSThread sleepForTimeInterval:2.0f]; // waiting for app Messages
    MSLog(@"login success");
}

- (void)logout
{
    MSLog(@"logouting");
//    [NSThread sleepForTimeInterval:2.0f];
    [self runAppleScript:self.logoutScripts];
    [NSThread sleepForTimeInterval:2.0f];
    MSLog(@"logout success");
}

- (BOOL)sendMessage:(MSMessage *)message
{
    MSAsyncScriptMessageSender *ms = [[[MSAsyncScriptMessageSender alloc] initWithScript:self.sendMessageScripts] autorelease];
    return [ms sendMessage:message];
}

@end

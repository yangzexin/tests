//
//  AppDelegate.m
//  MessageSlave
//
//  Created by yangzexin on 13-4-11.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "MSAppDelegate.h"
#import "MSConsoleController.h"
#import "MSMessageSender.h"
#import "SVCodeUtils.h"

@implementation MSAppDelegate

- (void)dealloc
{
    self.consoleController = nil;
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self.consoleController showWindow:nil];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    return YES;
}

- (void)messageDidSend:(NSPasteboard *)pasteboard userData:(id)data error:(NSError **)error
{
    [[NSAlert alertWithMessageText:@"comming" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@""] runModal];
    NSString *type = [pasteboard availableTypeFromArray:[NSArray arrayWithObject:(NSString *)kUTTypePlainText]];
    NSString *message = nil;
    if(type && (message = [pasteboard stringForType:type])){
        
    }
}

- (IBAction)messageSentCallback:(id)sender
{
    NSString *message = [[NSPasteboard generalPasteboard] stringForType:NSStringPboardType];
    NSArray *stringArray = [message componentsSeparatedByString:@";"];
    if(stringArray.count == 3){
        NSString *number = [stringArray objectAtIndex:2];
        [[NSNotificationCenter defaultCenter] postNotificationName:kMessageDidSendCallbackNotification object:number];
    }
}

@end

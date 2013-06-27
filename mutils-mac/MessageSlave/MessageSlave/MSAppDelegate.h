//
//  AppDelegate.h
//  MessageSlave
//
//  Created by yangzexin on 13-4-11.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MSConsoleController;

@interface MSAppDelegate : NSObject <NSApplicationDelegate>

@property(nonatomic, retain)IBOutlet MSConsoleController *consoleController;

- (IBAction)messageSentCallback:(id)sender;

@end

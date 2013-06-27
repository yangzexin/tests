//
//  AppDelegate.h
//  MessageProbe
//
//  Created by yangzexin on 6/10/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define kDestinationFieldWidthNotification @"kDestinationFieldWidthNotification"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property(assign)IBOutlet NSTextField *txtFilePathField;
@property(assign)IBOutlet NSButton *probeButton;
@property(assign)IBOutlet NSButton *pauseButton;
@property(assign)IBOutlet NSTextView *logTextView;
@property(assign)IBOutlet NSButton *onlineProbeButton;
@property(assign)IBOutlet NSTextField *onlineServerAddress;

- (IBAction)openTxtFile:(id)sender;
- (IBAction)probeButtonTapped:(id)sender;
- (IBAction)pauseButtonTapped:(id)sender;
- (IBAction)onlineProbeButtonTapped:(id)sender;
- (IBAction)normalCallback:(id)sender;

@end

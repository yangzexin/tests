//
//  ConsoleController.h
//  MessageSlave
//
//  Created by yangzexin on 13-4-11.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MSConsoleController : NSWindowController

@property(nonatomic, retain)IBOutlet NSButton *controlButton;
@property(nonatomic, retain)IBOutlet NSTextView *logTextView;
@property(nonatomic, retain)IBOutlet NSTextField *txtNumbersFilePathTextField;
@property(nonatomic, retain)IBOutlet NSTextField *appleIdTextField;
@property(nonatomic, retain)IBOutlet NSTextField *appleIdPasswordTextField;
@property(nonatomic, retain)IBOutlet NSTextView *messageContentTextField;
@property(nonatomic, retain)IBOutlet NSTextField *serverURLTextField;
@property(nonatomic, retain)IBOutlet NSButton *serverControlButton;

- (IBAction)controlButtonClicked:(NSButton *)button;
- (IBAction)openTxtNumbersButtonClicked:(id)sender;
- (IBAction)startServerSend:(id)sender;

@end

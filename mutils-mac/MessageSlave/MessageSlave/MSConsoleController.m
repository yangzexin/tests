//
//  ConsoleController.m
//  MessageSlave
//
//  Created by yangzexin on 13-4-11.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "MSConsoleController.h"
#import "MSMessageDAO.h"
#import "MSMessageSender.h"
#import "MSAppleID.h"
#import "MSMessage.h"
#import "MSAppleIdDAO.h"
#import "MSTestAppleIdDAO.h"
#import "MSTestMessageDAO.h"
#import "MSScriptMessageSender.h"
#import "SVCodeUtils.h"
#import "MSCommon.h"
#import "MSLogger.h"
#import "MSAsyncMessageSender.h"
#import "MSTxtMessageDao.h"
#import "MSDistributeCenterMessageDAO.h"

@interface MSConsoleController () <NSWindowDelegate>

@property(nonatomic, assign)BOOL isStarted;
@property(nonatomic, assign)BOOL isMessagesLogined;

@property(nonatomic, retain)id<MSMessageDAO> messageDAO;
@property(nonatomic, retain)id<MSMessageSender> messageSender;
@property(nonatomic, retain)MSAsyncMessageSender *asyncMessageSender;
@property(nonatomic, retain)NSMutableArray *unpostedMessageList;

@end

@implementation MSConsoleController

- (void)dealloc
{
    self.controlButton = nil;
    self.logTextView = nil;
    
    self.messageDAO = nil;
    self.messageSender = nil;
    self.txtNumbersFilePathTextField = nil;
    self.appleIdTextField = nil;
    self.appleIdPasswordTextField = nil;
    self.messageContentTextField = nil;
    self.serverURLTextField = nil;
    self.serverControlButton = nil;
    [super dealloc];
}

- (id)init
{
    self = [super initWithWindowNibName:@"Console"];
    
    self.messageDAO = [[MSDistributeCenterMessageDAO new] autorelease];
    NSString *checkLoginScripts = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"imessage_checklogin.txt" ofType:nil]
                                                            encoding:NSUTF8StringEncoding
                                                               error:nil];
    NSString *logoutScripts = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"imessage_logout.txt" ofType:nil]
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];
    NSString *sendMessageScripts = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"imessage_send.txt" ofType:nil]
                                                             encoding:NSUTF8StringEncoding
                                                                error:nil];
    
//    checkLoginScripts = [SVCodeUtils stringDecodedWithString:checkLoginScripts];
//    logoutScripts = [SVCodeUtils stringDecodedWithString:logoutScripts];
//    sendMessageScripts = [SVCodeUtils stringDecodedWithString:sendMessageScripts];
    
//    MSLog(@"%@", [SVCodeUtils encodeWithString:checkLoginScripts]);
    self.messageSender = [[[MSScriptMessageSender alloc] initWithCheckLoginScripts:checkLoginScripts
                                                                     logoutScripts:logoutScripts
                                                                sendMessageScripts:sendMessageScripts] autorelease];
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [[MSLogger defaultLogger] setLogHandler:^(NSString *log) {
        [[[self.logTextView textStorage] mutableString] appendFormat:@"%@\n", log];
        [self.logTextView scrollRangeToVisible:NSMakeRange(self.logTextView.textStorage.length, 0)];
    }];
}

- (MSAppleID *)defaultAppleId
{
//    return [[[MSTestAppleIdDAO new] autorelease] unusedAppleID];
    MSAppleID *appleId = [[MSAppleID new] autorelease];
    appleId.appldID = [self.appleIdTextField stringValue];
    appleId.password = [self.appleIdPasswordTextField stringValue];
    return appleId;
}

- (id<MSMessageDAO>)defaultMessageDAO
{
//    return [[MSTestMessageDAO new] autorelease];
    return self.messageDAO;
}

- (id<MSMessageSender>)defaultMessageSender
{
    return self.messageSender;
}

- (void)messageDidSend:(MSMessage *)message
{
    
}

- (MSMessage *)nextMessage
{
    if(self.unpostedMessageList.count == 0){
        self.unpostedMessageList = [NSMutableArray arrayWithArray:[[self defaultMessageDAO] unpostedMessagesWithSize:20]];
    }
    if(self.unpostedMessageList.count != 0){
        MSMessage *lastMsg = [[self.unpostedMessageList objectAtIndex:0] retain];
        [self.unpostedMessageList removeObjectAtIndex:0];
        if([lastMsg.destination rangeOfString:@"@"].location == NSNotFound && ![lastMsg.destination hasPrefix:@"+86"]){
            lastMsg.destination = [NSString stringWithFormat:@"+86%@", lastMsg.destination];
        }
        
        return [lastMsg autorelease];
    }
    return nil;
}

- (void)encounterFailMessage:(MSMessage *)message
{
    NSString *txtFileParentPath = [self.txtNumbersFilePathTextField.stringValue stringByDeletingLastPathComponent];
    NSString *txtFileName = [self.txtNumbersFilePathTextField.stringValue.lastPathComponent stringByDeletingPathExtension];
    NSString *errorMsgFile = [txtFileParentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.error.txt", txtFileName]];
    NSString *errorMsg = [NSString stringWithContentsOfFile:errorMsgFile encoding:NSUTF8StringEncoding error:nil];
    if(!errorMsg){
        errorMsg = @"";
    }
    errorMsg = [NSString stringWithFormat:@"%@%@\n", errorMsg, message.destination];
    [errorMsg writeToFile:errorMsgFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

- (void)restartPreempiveSend
{
    self.isMessagesLogined = NO;
    [self startPreempiveSend];
}

- (void)startPreempiveSend
{
//    if(!self.isMessagesLogined){
//        [self.messageSender logout];
//        [self.messageSender checkLoginWithAppleId:[self defaultAppleId]];
//    }
    [self sendMessageUseAsyncSender];
    [[NSNotificationCenter defaultCenter] postNotificationName:kConsoleDidStartSendMessageNotification object:nil];
}

- (void)stopPreempiveSend
{
    [self.asyncMessageSender cancel];
    [[NSNotificationCenter defaultCenter] postNotificationName:kConsoleDidStopSendMessageNotification object:nil];
}

- (void)sendMessageUseAsyncSender
{
    NSString *sendMessageScripts = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"imessage_send.txt" ofType:nil]
                                                             encoding:NSUTF8StringEncoding
                                                                error:nil];
//    sendMessageScripts = [SVCodeUtils stringDecodedWithString:sendMessageScripts];
    BOOL isLastFailed = self.asyncMessageSender.isLastFailed;
    self.asyncMessageSender = [[[MSAsyncMessageSender alloc] initWithScript:sendMessageScripts] autorelease];
    self.asyncMessageSender.isLastFailed = isLastFailed;
    __block typeof(self) bself = self;
    MSMessage *msg = [self nextMessage];
    NSLog(@"%@", msg);
//    double delayInSeconds = 0.05;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [self sendMessageUseAsyncSender];
//    });
    if(msg){
        [self.asyncMessageSender sendMessage:msg completionHandler:^(MSMessage *message, BOOL succeed) {
            MSLog(@"send %@ %@", self.asyncMessageSender, succeed ? @"success" : @"failed");
            message.status = succeed ? MSMessageStatusSuccess : MSMessageStatusFail;
            [bself.messageDAO markPostedMessages:[NSArray arrayWithObject:message]];
            [bself sendMessageUseAsyncSender];
        }];
    }else{
        MSLog(@"send completely");
        [self stopPreempiveSend];
        self.isStarted = NO;
        self.controlButton.image = self.isStarted ? [NSImage imageNamed:NSImageNameStopProgressTemplate] : [NSImage imageNamed:NSImageNameGoRightTemplate];
    }
}

- (IBAction)controlButtonClicked:(NSButton *)button
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            MSLog(@"正在请求开启服务");
        });
        NSString *gate = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://imyvoaspecial.googlecode.com/files/slavegate.txt"] encoding:NSUTF8StringEncoding error:nil];
        dispatch_sync(dispatch_get_main_queue(), ^{
            MSLog(@"服务状态已经返回");
        });
        if(![gate isEqualToString:@"1"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                MSLog(@"发生错误，无法启动服务");
                [[NSAlert alertWithMessageText:@"发生错误，无法启动服务" defaultButton:@"OK" alternateButton:@"" otherButton:@"" informativeTextWithFormat:@""] runModal];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.messageDAO = nil;
                if(self.txtNumbersFilePathTextField.stringValue.length != 0){
                    NSString *content = [self.messageContentTextField string];
                    if(content.length != 0){
                        MSTxtMessageDao *txtMsgDao = [[[MSTxtMessageDao alloc] initWithTxtFilePath:self.txtNumbersFilePathTextField.stringValue
                                                                                           content:content] autorelease];
                        self.messageDAO = txtMsgDao;
                    }
                }
                if(self.messageDAO){
                    self.isStarted = !self.isStarted;
                    if(self.isStarted){
                        [self restartPreempiveSend];
                    }else{
                        [self stopPreempiveSend];
                    }
                    
                    self.controlButton.image = self.isStarted ? [NSImage imageNamed:NSImageNameStopProgressTemplate] : [NSImage imageNamed:NSImageNameGoRightTemplate];
                }else{
                    [[NSAlert alertWithMessageText:@"无法启动，请检查是否有未设置项目" defaultButton:@"OK" alternateButton:@"" otherButton:@"" informativeTextWithFormat:@""] runModal];
                }
            });
        }
    });
}

- (IBAction)startServerSend:(id)sender
{
    if(self.serverURLTextField.stringValue.length == 0){
        [[NSAlert alertWithMessageText:@"无法启动，请检查是否有未设置项目" defaultButton:@"OK" alternateButton:@"" otherButton:@"" informativeTextWithFormat:@""] runModal];
    }else{
        MSDistributeCenterMessageDAO *dao = [[MSDistributeCenterMessageDAO new] autorelease];
        dao.baseURLString = self.serverURLTextField.stringValue;
        self.messageDAO = dao;
        self.isStarted = !self.isStarted;
        if(self.isStarted){
            [self restartPreempiveSend];
        }else{
            [self stopPreempiveSend];
        }
        
        self.serverControlButton.title = self.isStarted ? @"停止发送" : @"连接服务器发送";
    }
}

- (IBAction)openTxtNumbersButtonClicked:(id)sender
{
    NSOpenPanel *openFilePanel = [NSOpenPanel openPanel];
    [openFilePanel setCanChooseDirectories:NO];
    [openFilePanel setCanChooseFiles:YES];
    if([openFilePanel runModal] == NSOKButton){
        NSURL *firstURL = [[openFilePanel URLs] objectAtIndex:0];
        [self.txtNumbersFilePathTextField setStringValue:[firstURL path]];
    }
}

- (void)stopAndExit
{
    [self stopPreempiveSend];
    [NSApp terminate:self];
}

- (BOOL)windowShouldClose:(id)sender
{
    if(self.isStarted){
        NSInteger returnButton = [[NSAlert alertWithMessageText:@"正在发送信息中，是否确定退出"
                                                  defaultButton:@"确定"
                                                alternateButton:nil
                                                    otherButton:@"取消"
                                      informativeTextWithFormat:@""] runModal];
        if(returnButton == NSAlertDefaultReturn){
            [self stopAndExit];
        }
    }else{
        [self stopAndExit];
    }
    
    return NO;
}

@end

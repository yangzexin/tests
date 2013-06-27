//
//  AppDelegate.m
//  MessageProbe
//
//  Created by yangzexin on 6/10/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import "AppDelegate.h"
#import "SVAccountContentProvider.h"
#import "SVAccountProbe.h"
#import "SVMessageAccount.h"
#import "SVAccountMarker.h"

@interface AppDelegate ()

@property(nonatomic, retain)id<SVAccountContentProvider> accountContentProvider;
@property(nonatomic, retain)SVAccountProbe *accountProbe;
@property(nonatomic, retain)id<SVAccountMarker> accountMarker;
@property(nonatomic, assign)BOOL started;
@property(nonatomic, assign)BOOL paused;
@property(nonatomic, assign)BOOL onlineProbe;
@property(nonatomic, assign)BOOL preventable;

@end

@implementation AppDelegate

- (void)dealloc
{
    self.accountContentProvider = nil;
    self.accountProbe = nil;
    self.accountMarker = nil;
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [[MSLogger defaultLogger] setLogHandler:^(NSString *log) {
        [[[self.logTextView textStorage] mutableString] appendFormat:@"%@\n", log];
        if(self.logTextView.textStorage.mutableString.length > 7000){
            [self.logTextView.textStorage.mutableString deleteCharactersInRange:NSMakeRange(0, self.logTextView.textStorage.mutableString.length)];
        }
        [self.logTextView scrollRangeToVisible:NSMakeRange(self.logTextView.textStorage.length, 0)];
    }];
    [self _probeStatusDidChange];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    [self.window makeKeyAndOrderFront:self];
    return YES;
}

#pragma mark - private methods
- (void)_probeWillStart
{
    self.accountProbe = [SVAccountProbe sharedInstance];
}

- (void)_probeDidStart
{
    NSLog(@"probe did start");
}

- (void)_probeDidFinish
{
    [self.accountMarker save];
}

- (void)_continueProbe
{
//    SVMessageAccount *account = [self.accountContentProvider nextAccount];
//    if(account){
//        MSLog(@"正在探测:%@", account);
//        BOOL messageAccount = [self.accountProbe isIMessageAccount:account];
//        [self.accountMarker markAccount:account isIMessageAccount:messageAccount];
//        BOOL messageAccount = YES;
//        [NSThread sleepForTimeInterval:0.001f];
//        MSLog(@"探测完成:%@, %@\n", account, messageAccount ? @"是" : @"不是");
//        if(self.started && !self.paused){
//            NSInteger sleep = arc4random() % 5;
//            MSLog(@"sleep %lds", sleep);
//            [NSThread sleepForTimeInterval:sleep];
//            [self _continueProbe];
//        }else{
//            [self.accountMarker save];
//        }
//    }else{
//        self.started = NO;
//        [self _probeStatusDidChange];
//    }
    SVMessageAccount *tmpAccount = nil;
    while((tmpAccount = [self.accountContentProvider nextAccount]) != nil){
        @autoreleasepool {
            BOOL messageAccount = [self.accountProbe isIMessageAccount:tmpAccount];
            [self.accountMarker markAccount:tmpAccount isIMessageAccount:messageAccount];
            MSLog(@"探测完成:%@, %@\n", tmpAccount, messageAccount ? @"是" : @"不是");
            if(self.started && !self.paused & self.preventable){
                NSInteger sleep = arc4random() % 5;
                MSLog(@"prevent pop window sleep %lds", sleep);
                [NSThread sleepForTimeInterval:sleep];
            }
            if(self.started && !self.paused){
                continue;
            }else{
                [self.accountMarker save];
                break;
            }
        }
    }
}

- (void)_pauseProbe
{
    self.paused = YES;
}

- (void)_resumeProbe
{
    self.paused = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self _continueProbe];
    });
}

- (void)_probeStatusDidChange
{
    if(!self.onlineProbe){
        self.probeButton.title = self.started ? @"停止探测" : @"开始探测";
    }else{
        self.onlineProbeButton.title = self.started ? @"停止探测" : @"连接服务器探测";
    }
    [self.pauseButton setEnabled:self.started];
    self.pauseButton.title = self.started ? self.paused ? @"继续" : @"暂停" : @"暂停";
    if(!self.started){
        [self.accountContentProvider cancel];
        [self.accountProbe cancel];
    }
    [self.accountProbe reset];
}

#pragma mark - events
- (IBAction)openTxtFile:(id)sender
{
    NSOpenPanel *openFilePanel = [NSOpenPanel openPanel];
    [openFilePanel setCanChooseDirectories:NO];
    [openFilePanel setCanChooseFiles:YES];
    if([openFilePanel runModal] == NSOKButton){
        NSURL *firstURL = [[openFilePanel URLs] objectAtIndex:0];
        [self.txtFilePathField setStringValue:[firstURL path]];
    }
}

- (IBAction)probeButtonTapped:(id)sender
{
    self.onlineProbe = NO;
    if(!self.started){
        if(self.txtFilePathField.stringValue.length == 0){
            [[NSAlert alertWithMessageText:@"必须选择一个txt文件" defaultButton:@"OK" alternateButton:@"Cancel" otherButton:@"" informativeTextWithFormat:@""] runModal];
            return;
        }
        [self _probeWillStart];
        self.started = YES;
        NSString *txtFilePath = self.txtFilePathField.stringValue;
        self.accountContentProvider = [[[SVTxtFileAccountContentProvider alloc] initWithTxtFilePath:txtFilePath] autorelease];
        NSString *markFilePath = [NSString stringWithFormat:@"%@.mark.txt", [txtFilePath stringByDeletingPathExtension]];
        self.accountMarker = [[[SVTxtAccountMarker alloc] initWithFilePath:markFilePath] autorelease];
        [self _resumeProbe];
    }else{
        self.started = NO;
        MSLog(@"已停止");
    }
    [self _probeStatusDidChange];
}

- (IBAction)pauseButtonTapped:(id)sender
{
    self.paused = !self.paused;
    [self _probeStatusDidChange];
    if(!self.paused){
        [self _resumeProbe];
    }else{
        [self.pauseButton setEnabled:NO];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            const NSInteger waitSeconds = 7;
            for(NSInteger i = 0; i < waitSeconds; ++i){
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.pauseButton.title = [NSString stringWithFormat:@"%ld秒", waitSeconds - i];
                });
                [NSThread sleepForTimeInterval:1.0f];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self _probeStatusDidChange];
            });
        });
    }
}

- (IBAction)onlineProbeButtonTapped:(id)sender
{
    self.onlineProbe = YES;
    if(!self.started){
        NSString *serverAddress = [self.onlineServerAddress.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if(serverAddress.length == 0){
            [[NSAlert alertWithMessageText:@"请填写服务器地址" defaultButton:@"OK" alternateButton:@"Cancel" otherButton:@"" informativeTextWithFormat:@""] runModal];
            return;
        }
        if(![serverAddress hasPrefix:@"http://"]){
            serverAddress = [NSString stringWithFormat:@"http://%@", serverAddress];
        }
//        NSError *error = nil;;
//        [NSString stringWithContentsOfURL:[NSURL URLWithString:serverAddress] encoding:NSUTF8StringEncoding error:&error];
//        if(error){
//            [[NSAlert alertWithMessageText:@"连接服务器失败" defaultButton:@"OK" alternateButton:@"Cancel" otherButton:@"" informativeTextWithFormat:@""] runModal];
//            return;
//        }
        [self _probeWillStart];
        self.started = YES;
        self.accountContentProvider = [[[SVOnlineAccountContentProvider alloc] initWithURLString:[NSString stringWithFormat:@"%@/messagelord/userProbeList.do", serverAddress]] autorelease];
        self.accountMarker = [[[SVOnlineAccountMarker alloc] initWithBaseURLString:[NSString stringWithFormat:@"%@/messagelord/markProbeResult.do", serverAddress]] autorelease];
        [self _resumeProbe];
        [self _probeStatusDidChange];
    }else{
        self.started = NO;
        MSLog(@"已停止");
        [self.onlineProbeButton setEnabled:NO];
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.onlineProbeButton setEnabled:YES];
            [self _probeStatusDidChange];
        });
    }
}

- (IBAction)normalCallback:(id)sender
{
    NSString *message = [[NSPasteboard generalPasteboard] stringForType:NSStringPboardType];
    if([message hasPrefix:@"001"]){// text field lenth callback
        message = [message substringFromIndex:3];
        message = [message substringToIndex:3];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDestinationFieldWidthNotification object:message];
    }
}

- (IBAction)switchPreventability:(id)sender
{
    self.preventable = !self.preventable;
}

@end

//
//  AppDelegate.m
//  ImageEditorTest
//
//  Created by yangzexin on 13-7-1.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "AppDelegate.h"
#import "YXImageEditor.h"

static NSDictionary *keyCodeValueImageName = nil;

@interface AppDelegate ()

@property(nonatomic, retain)YXImageEditor *editor;

@end

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    keyCodeValueImageName = [@{
                              @"0" : @"account_money.png",
                              @"1" : @"btn_passbook.png",
                              @"2" : @"account_money.png",
                              @"3" : @"btn_passbook.png",
                              @"4" : @"account_money.png"
                              } retain];
    
    self.editor = [[[YXImageEditor alloc] initWithFrame:CGRectMake(0, 20, 320, 200)] autorelease];
    self.editor.imageLeftMatchingText = @"[";
    self.editor.imageRightMatchingText = @"]";
    [self.editor setImageGetter:^UIImage *(NSString *imageName) {
        return [UIImage imageNamed:[keyCodeValueImageName valueForKey:imageName]];
    }];
    [self.window addSubview:self.editor];
    
    for(NSInteger i = 0; i < 5; ++i){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitle:[NSString stringWithFormat:@"[%d]", i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(60 * i, 210, 50, 50);
        btn.tag = i;
        [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.window addSubview:btn];
    }
    
    return YES;
}

- (void)buttonTapped:(UIButton *)btn
{
    [self.editor insertText:btn.currentTitle];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

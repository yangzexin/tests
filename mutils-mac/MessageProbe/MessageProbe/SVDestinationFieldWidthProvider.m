//
//  SVMessagesInformation.m
//  MessageProbe
//
//  Created by yangzexin on 13-6-13.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "SVDestinationFieldWidthProvider.h"
#import "AppDelegate.h"

@interface SVDestinationFieldWidthProvider ()

@property(nonatomic, assign)BOOL scriptRunning;
@property(nonatomic, assign)CGFloat cachedWidth;
@property(nonatomic, copy)void(^completionHandler)(CGFloat);

@end

@implementation SVDestinationFieldWidthProvider

+ (void)runAppleScript:(NSString *)script
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.completionHandler = nil;
    [super dealloc];
}

- (void)widthWithCompletionHandler:(void(^)(CGFloat width))completionHandler
{
    self.completionHandler = completionHandler;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callbackNotification:) name:kDestinationFieldWidthNotification object:nil];
    self.scriptRunning = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *script = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"destinationFieldWithScript.txt" ofType:nil]
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
        [self.class runAppleScript:script];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        double delayInSeconds = 3.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if(self.scriptRunning){
                self.scriptRunning = NO;
                completionHandler(0.0f);
            }
        });
    });
}

- (void)callbackNotification:(NSNotification *)n
{
    self.scriptRunning = NO;
    if(self.completionHandler){
        self.completionHandler([n.object floatValue]);
    }
}


@end

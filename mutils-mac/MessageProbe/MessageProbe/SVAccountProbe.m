//
//  SViMessageFiller.m
//  MessageProbe
//
//  Created by yangzexin on 6/10/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import "SVAccountProbe.h"
#import "SVMessageAccount.h"
#import "SVSystemUtils.h"
#import "SVDestinationFieldWidthProvider.h"
#import "SVCodeUtils.h"

@interface SVAccountProbe ()

@property(nonatomic, copy)NSString *script;
@property(nonatomic, assign)CGFloat destinationFieldWidth;
@property(nonatomic, assign)BOOL destinationFieldCached;
@property(nonatomic, assign)int processIdentifier;

@end

@implementation SVAccountProbe

+ (id)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self.class new] autorelease];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    
    self.script = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fillScript" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    self.destinationFieldWidth = 0.0f;
    
    return self;
}

- (void)runAppleScript:(NSString *)script
{
//    MSLog(@"run script:\n%@", script);
//    NSAppleScript *appleScript = [[[NSAppleScript alloc] initWithSource:script] autorelease];
    
//    NSDictionary *compileError = nil;
//    [appleScript compileAndReturnError:&compileError];
//    MSLog(@"script compile error:%@", compileError);
    
//    NSDictionary *executeError = nil;
//    [appleScript executeAndReturnError:&executeError];
//    MSLog(@"script execute error:%@", executeError);
    NSString *taskName = @"script_runner";
    NSString *runnerPath = [[NSBundle mainBundle] pathForResource:taskName ofType:nil];;
    NSTask *runnerTask = [NSTask launchedTaskWithLaunchPath:runnerPath arguments:[NSArray arrayWithObject:[SVCodeUtils encodeWithString:script]]];
    self.processIdentifier = runnerTask.processIdentifier;
    __block BOOL running = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while(YES){
            [NSThread sleepForTimeInterval:0.05f];
            running = runnerTask.isRunning;
            if(!running){
                break;
            }
        }
    });
    while(running){
        [NSThread sleepForTimeInterval:0.05f];
    }
    NSLog(@"script execute finish");
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

- (BOOL)confirmDestinationFieldWidth
{
    if(!self.destinationFieldCached || self.destinationFieldWidth == 0.0f){
        __block BOOL waiting = YES;
        SVDestinationFieldWidthProvider *widthProvider = [SVDestinationFieldWidthProvider new];
        [widthProvider widthWithCompletionHandler:^(CGFloat width) {
            self.destinationFieldWidth = width;
            MSLog(@"get position success:%f", width);
            self.destinationFieldCached = YES;
            waiting = NO;
            [widthProvider release];
        }];
        while(waiting){
            [NSThread sleepForTimeInterval:.01f];
        }
    }
    return self.destinationFieldWidth == 0.0f;
}

- (BOOL)isIMessageAccount:(SVMessageAccount *)account
{
    while([self confirmDestinationFieldWidth]){}
    MSLog(@"checking MessageAccount:%@", account.account);
    NSString *script = self.script;
    NSString *destination = account.account;
    
    if([destination rangeOfString:@"@"].location == NSNotFound && ![destination hasPrefix:@"+86"]){
        destination = [NSString stringWithFormat:@"+86%@", destination];
    }
    script = [script stringByReplacingOccurrencesOfString:@"$destination" withString:[self filterScriptVariable:destination]];
    script = [script stringByReplacingOccurrencesOfString:@"$messageContent" withString:[self filterScriptVariable:@""]];
    
    [self runAppleScript:script];
//    NSString *locale = [[NSLocale preferredLanguages] objectAtIndex:0];
//    CGFloat additionalX = [[locale lowercaseString] isEqualToString:@"en"] ? 0.0f : 27.0f;
    CGPoint checkPoint = CGPointMake(self.destinationFieldWidth + 10, 58);
    NSLog(@"%f,%f", checkPoint.x, checkPoint.y);
    NSColor *color = [SVSystemUtils colorOfScreenPixelAtPoint:checkPoint];
    NSLog(@"%@", color);
    const CGFloat red = 0.827451;
    const CGFloat green = 0.87451;
    const CGFloat blue = 0.964706;
    CGFloat redDelta = color.redComponent - red;
    if(redDelta < 0.0f){
        redDelta = -redDelta;
    }
    CGFloat greenDelta = color.greenComponent - green;
    if(greenDelta < 0.0f){
        greenDelta = -greenDelta;
    }
    CGFloat blueDelta = color.blueComponent - blue;
    if(blueDelta < 0.0f){
        blueDelta = -blueDelta;
    }
    
    return redDelta < 0.05f && greenDelta < 0.05f && blueDelta < 0.05f;
}

- (void)reset
{
    self.destinationFieldCached = NO;
}

- (void)cancel
{
    NSString *command = [NSString stringWithFormat:@"kill %d", self.processIdentifier];
    system([command UTF8String]);
}

@end

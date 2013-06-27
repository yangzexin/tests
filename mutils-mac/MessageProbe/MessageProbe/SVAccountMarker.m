//
//  SVAccountMarker.m
//  MessageProbe
//
//  Created by yangzexin on 6/10/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import "SVAccountMarker.h"
#import "SVMessageAccount.h"

@interface SVTxtAccountMarker ()

@property(nonatomic, copy)NSString *filePath;
@property(nonatomic, retain)NSMutableString *marks;
@property(nonatomic, assign)NSInteger lastSavedOffset;

@end

@implementation SVTxtAccountMarker

- (void)dealloc
{
    [self save];
    self.filePath = nil;
    self.marks = nil;
    [super dealloc];
}

- (id)initWithFilePath:(NSString *)filePath
{
    self = [super init];
    
    self.filePath = filePath;
    self.marks = [NSMutableString string];
    
    return self;
}

- (void)markAccount:(SVMessageAccount *)account isIMessageAccount:(BOOL)isIMessageAccount
{
    [self.marks appendFormat:@"%@ %@\n", account.account, isIMessageAccount ? @"1" : @"0"];
    if(self.marks.length - self.lastSavedOffset > 20){
        [self save];
        self.lastSavedOffset = self.marks.length;
    }
}

- (void)save
{
    [self.marks writeToFile:self.filePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

@end

@interface SVOnlineAccountMarker ()

@property(nonatomic, copy)NSString *baseURLString;

@end

@implementation SVOnlineAccountMarker

- (void)dealloc
{
    self.baseURLString = nil;
    [super dealloc];
}

- (id)initWithBaseURLString:(NSString *)baseURLString
{
    self = [super init];
    
    self.baseURLString = baseURLString;
    
    return self;
}

- (void)markAccount:(SVMessageAccount *)account isIMessageAccount:(BOOL)isIMessageAccount
{
    NSString *URLString = [NSString stringWithFormat:@"%@?params=%@-%d", self.baseURLString, account.uid, isIMessageAccount ? 1 : 0];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *response = [NSString stringWithContentsOfURL:[NSURL URLWithString:URLString] encoding:NSUTF8StringEncoding error:nil];
        MSLog(@"markAccount:%@, %@", account.account, isIMessageAccount ? @"1" : @"0");
        NSLog(@"%@", response);
    });
}

- (void)save
{
}

@end
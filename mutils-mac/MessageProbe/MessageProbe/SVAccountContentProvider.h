//
//  SVAccountContentProvider.h
//  MessageProbe
//
//  Created by yangzexin on 6/10/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SVMessageAccount;

@protocol SVAccountContentProvider <NSObject>

- (SVMessageAccount *)nextAccount;
- (NSInteger)numberOfAccounts;
- (void)cancel;

@end

@interface SVTxtFileAccountContentProvider : NSObject <SVAccountContentProvider>

- (id)initWithTxtFilePath:(NSString *)txtFilePath;

@end

@interface SVOnlineAccountContentProvider : NSObject <SVAccountContentProvider>

- (id)initWithURLString:(NSString *)URLString;

@end
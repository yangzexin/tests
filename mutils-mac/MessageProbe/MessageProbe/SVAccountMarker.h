//
//  SVAccountMarker.h
//  MessageProbe
//
//  Created by yangzexin on 6/10/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SVMessageAccount;

@protocol SVAccountMarker <NSObject>

- (void)markAccount:(SVMessageAccount *)account isIMessageAccount:(BOOL)isIMessageAccount;
- (void)save;

@end

@interface SVTxtAccountMarker : NSObject <SVAccountMarker>

- (id)initWithFilePath:(NSString *)filePath;

@end

@interface SVOnlineAccountMarker : NSObject <SVAccountMarker>

- (id)initWithBaseURLString:(NSString *)baseURLString;

@end
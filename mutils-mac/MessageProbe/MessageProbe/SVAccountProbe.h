//
//  SViMessageFiller.h
//  MessageProbe
//
//  Created by yangzexin on 6/10/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SVMessageAccount;

@interface SVAccountProbe : NSObject

+ (id)sharedInstance;

- (BOOL)isIMessageAccount:(SVMessageAccount *)account;
- (void)reset;
- (void)cancel;

@end

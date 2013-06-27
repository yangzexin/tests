//
//  SVMessageAccount.m
//  MessageProbe
//
//  Created by yangzexin on 6/10/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import "SVMessageAccount.h"

@implementation SVMessageAccount

- (void)dealloc
{
    self.uid = nil;
    self.account = nil;
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", self.account];
}

@end

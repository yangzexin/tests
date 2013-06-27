//
//  MSAppleID.m
//  MessageSlave
//
//  Created by yangzexin on 13-4-11.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "MSAppleID.h"

@implementation MSAppleID

- (void)dealloc
{
    self.appldID = nil;
    self.password = nil;
    [super dealloc];
}

@end

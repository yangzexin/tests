//
//  MSMessage.m
//  MessageSlave
//
//  Created by yangzexin on 13-4-11.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "MSMessage.h"

@implementation MSMessage

- (void)dealloc
{
    self.uid = nil;
    self.content = nil;
    self.destination = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    self.status = MSMessageStatusUnhandle;
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@, %@", self.uid, self.content, self.destination];
}

@end

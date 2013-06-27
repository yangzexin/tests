//
//  MSTestAppleIdDAO.m
//  MessageSlave
//
//  Created by yangzexin on 13-4-11.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "MSTestAppleIdDAO.h"
#import "MSAppleID.h"

@implementation MSTestAppleIdDAO

- (MSAppleID *)unusedAppleID
{
    MSAppleID *appldID = [[MSAppleID new] autorelease];
    appldID.appldID = @"a8613727270001@163.com";
    appldID.password = @"Mima1204512045";
    return appldID;
}

- (void)updateStatusWithAppleID:(MSAppleID *)appldID
{
}

@end

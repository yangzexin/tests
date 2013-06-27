//
//  MSAppleIdDAO.h
//  MessageSlave
//
//  Created by yangzexin on 13-4-11.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSAppleID;

@protocol MSAppleIdDAO <NSObject>

- (MSAppleID *)unusedAppleID;
- (void)updateStatusWithAppleID:(MSAppleID *)appldID;

@end

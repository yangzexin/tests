//
//  MSScriptMessageSender.h
//  MessageSlave
//
//  Created by yangzexin on 13-4-11.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSMessageSender.h"

@interface MSScriptMessageSender : NSObject <MSMessageSender>

- (id)initWithCheckLoginScripts:(NSString *)checkLoginScripts logoutScripts:(NSString *)logoutScripts sendMessageScripts:(NSString *)sendMessageScripts;

@end

//
//  MSDistributeCenterMessageDAO.h
//  MessageSlave
//
//  Created by yangzexin on 13-4-24.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSMessageDAO.h"

@interface MSDistributeCenterMessageDAO : NSObject <MSMessageDAO>

@property(nonatomic, copy)NSString *baseURLString;

@end

//
//  MSMessageDAO.h
//  MessageSlave
//
//  Created by yangzexin on 13-4-11.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MSMessageDAO <NSObject>

- (NSArray *)unpostedMessagesWithSize:(NSInteger)size;
- (void)markPostedMessages:(NSArray *)messages;

@end

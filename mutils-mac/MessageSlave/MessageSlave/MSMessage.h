//
//  MSMessage.h
//  MessageSlave
//
//  Created by yangzexin on 13-4-11.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    MSMessageStatusUnhandle,
    MSMessageStatusSuccess,
    MSMessageStatusFail
}MSMessageStatus;

@interface MSMessage : NSObject

@property(nonatomic, copy)NSString *uid;
@property(nonatomic, copy)NSString *content;
@property(nonatomic, copy)NSString *destination;
@property(nonatomic, assign)MSMessageStatus status;
@property(nonatomic, assign)NSInteger retryCount;

@end

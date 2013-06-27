//
//  MSTestMessageDAO.m
//  MessageSlave
//
//  Created by yangzexin on 13-4-11.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "MSTestMessageDAO.h"
#import "MSMessage.h"

@implementation MSTestMessageDAO

- (NSArray *)unpostedMessagesWithSize:(NSInteger)size
{
//    NSString *baseNumber = @"+86186021";
//    NSMutableArray *msgs = [NSMutableArray array];
//    for(NSInteger i = 0; i < size; ++i){
//        MSMessage *message = [[MSMessage new] autorelease];
//        message.destination = [NSString stringWithFormat:@"%@%05d", baseNumber, (rand() % 72222) + 20000];
//        message.content = @"😄😄😄😄😄😄😄";
//        [msgs addObject:message];
//    }
//    NSMutableArray *msgs = [NSMutableArray array];
//    for(NSInteger i = 0; i < size; ++i){
//        MSMessage *message = [[MSMessage new] autorelease];
//        if(i % 4 == 0){
//            message.destination = @"+8618607072318";
//        }else if(i % 5 == 0){
//            message.destination = @"+8618616353349";
//        }else{
//            message.destination = @"+8618607072328";
//        }
//        
//        message.content = @"😄😄😄😄😄😄😄";
//        [msgs addObject:message];
//    }
    NSArray *numbers = @[@"18601769411", @"18930878835"];
    NSMutableArray *msgs = [NSMutableArray array];
    for(NSString *number in numbers){
        MSMessage *message = [[MSMessage new] autorelease];
        message.destination = [NSString stringWithFormat:@"+86%@", number];
        message.content = @"亲，这是imessage群发测试哦~~~";
        [msgs addObject:message];
    }
    return msgs;
}

- (void)markPostedMessages:(NSArray *)messages
{
    for(MSMessage *message in messages){
        if(message.status == MSMessageStatusSuccess){
            MSLog(@"%@ is iMessage user", message.destination);
        }
    }
}

@end

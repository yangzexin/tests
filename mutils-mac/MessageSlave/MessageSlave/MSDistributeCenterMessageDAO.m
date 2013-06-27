//
//  MSDistributeCenterMessageDAO.m
//  MessageSlave
//
//  Created by yangzexin on 13-4-24.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "MSDistributeCenterMessageDAO.h"
#import "MSMessage.h"

@implementation MSDistributeCenterMessageDAO

- (void)dealloc
{
    self.baseURLString = nil;
    [super dealloc];
}

- (NSArray *)unpostedMessagesWithSize:(NSInteger)size
{
    NSString *urlString = [NSString stringWithFormat:@"%@/GetContact.ashx?NUmber=%ld", [self baseURLString], size];
    MSLog(@"%@", urlString);
    NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil];
    MSLog(@"%@", string);
    if(string.length != 0){
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
        NSError *error = nil;
        NSArray *list = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        MSLog(@"%@", list);
        NSMutableArray *tmpMsgList = [NSMutableArray array];
        for(NSDictionary *tmpDict in list){
            MSMessage *tmpMsg = [[MSMessage new] autorelease];
            tmpMsg.content = [tmpDict objectForKey:@"Content"];
            tmpMsg.destination = [tmpDict objectForKey:@"Mobile"];
            tmpMsg.uid = [tmpDict objectForKey:@"ID"];
            
            [tmpMsgList addObject:tmpMsg];
        }
        return tmpMsgList;
    }
    return nil;
}

- (void)markPostedMessages:(NSArray *)messages
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for(MSMessage *msg in messages){
            NSString *urlString = [NSString stringWithFormat:@"%@/UpdateContactStatus.ashx?id=%@&status=1", [self baseURLString], msg.uid];
            NSString *response = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                MSLog(@"msg mark:%@, %@", msg.uid, response);
            });
        }
    });
}

@end

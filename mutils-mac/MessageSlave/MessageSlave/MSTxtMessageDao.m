//
//  MSTxtMessageDao.m
//  MessageSlave
//
//  Created by yangzexin on 13-4-28.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "MSTxtMessageDao.h"
#import "MSMessage.h"

@interface MSTxtMessageDao ()

@property(nonatomic, copy)NSString *txtFilePath;
@property(nonatomic, retain)NSMutableArray *messages;
@property(nonatomic, assign)NSInteger postedOffset;

@end

@implementation MSTxtMessageDao

- (void)dealloc
{
    self.txtFilePath = nil;
    [super dealloc];
}

- (id)initWithTxtFilePath:(NSString *)txtFilePath content:(NSString *)content
{
    self = [super init];
    
    self.txtFilePath = txtFilePath;
    self.postedOffset = 0;
    
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
    
    NSString *txt = [NSString stringWithContentsOfFile:self.txtFilePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *destinations = [txt componentsSeparatedByString:@"\n"];
    self.messages = [NSMutableArray array];
    for(NSString *tmpDestination in destinations){
        tmpDestination = [tmpDestination stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        tmpDestination = [tmpDestination stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
        if(tmpDestination.length != 0){
            MSMessage *msg = [[MSMessage new] autorelease];
            msg.destination = tmpDestination;
            msg.content = content;
            msg.uid = [NSString stringWithFormat:@"%ld", (unsigned long)[msg hash]];
            [self.messages addObject:msg];
        }
    }
    
    return self;
}

- (NSArray *)unpostedMessagesWithSize:(NSInteger)size
{
    NSMutableArray *unpostedMsgs = [NSMutableArray array];
    @synchronized(self){
        for(NSInteger i = self.postedOffset; i < self.messages.count && i < (size + self.postedOffset); ++i){
            [unpostedMsgs addObject:[self.messages objectAtIndex:i]];
        }
        self.postedOffset += size;
    }
    return unpostedMsgs;
}

- (void)markPostedMessages:(NSArray *)messages
{
    for(MSMessage *message in messages){
        NSString *txtFileName = [self.txtFilePath stringByDeletingPathExtension];
        NSString *errorMsgFile = [NSString stringWithFormat:@"%@.error.txt", txtFileName];
        NSString *errorMsg = [NSString stringWithContentsOfFile:errorMsgFile encoding:NSUTF8StringEncoding error:nil];
        if(!errorMsg){
            errorMsg = @"";
        }
        NSString *destination = message.destination;
        destination = [destination stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        destination = [destination stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
        errorMsg = [NSString stringWithFormat:@"%@%@\t%@\n", errorMsg, destination, message.status == MSMessageStatusSuccess ? @"1" : @"0"];
        [errorMsg writeToFile:errorMsgFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
    }
}

@end

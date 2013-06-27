//
//  SVHTTPRequest.m
//  MessageProbe
//
//  Created by yangzexin on 6/13/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import "SVHTTPRequest.h"

@interface SVHTTPRequest ()

@property(nonatomic, copy)void(^completionHandler)(id, NSError *);

@end

@implementation SVHTTPRequest

- (void)dealloc
{
    self.completionHandler = nil;
    [super dealloc];
}

- (void)requestWithURLString:(NSString *)URLString completionHandler:(void(^)(id, NSError *))completionHandler
{
    self.completionHandler = completionHandler;
    __block typeof(self) bself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        NSString *response = [NSString stringWithContentsOfURL:[NSURL URLWithString:URLString] encoding:NSUTF8StringEncoding error:&error];
        if(bself.completionHandler){
            error == nil ? bself.completionHandler(response, nil) : bself.completionHandler(nil, error);
        }
    });
}

- (void)cancel
{
    self.completionHandler = nil;
}

@end

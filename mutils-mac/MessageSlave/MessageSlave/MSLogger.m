//
//  MSLogger.m
//  MessageSlave
//
//  Created by yangzexin on 4/12/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import "MSLogger.h"

@implementation MSLogger

+ (id)defaultLogger
{
    static id instance = nil;
    @synchronized(self.class){
        if(instance == nil){
            instance = [self.class new];
        }
    }
    return instance;
}

- (void)log:(NSString *)log
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.logHandler){
            NSLog(@"%@", log);
            self.logHandler(log);
        }
    });
}

@end

//
//  SVHTTPRequest.h
//  MessageProbe
//
//  Created by yangzexin on 6/13/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVHTTPRequest : NSObject

- (void)requestWithURLString:(NSString *)URLString completionHandler:(void(^)(id, NSError *))completionHandler;
- (void)cancel;

@end

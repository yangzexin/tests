//
//  SVMessagesInformation.h
//  MessageProbe
//
//  Created by yangzexin on 13-6-13.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVDestinationFieldWidthProvider : NSObject

- (void)widthWithCompletionHandler:(void(^)(CGFloat width))completionHandler;

@end

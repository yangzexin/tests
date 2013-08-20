//
//  HTDrawableBlock.h
//  BuildMapDemo
//
//  Created by yangzexin on 8/20/13.
//  Copyright (c) 2013 hanting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface HTDrawableBlock : NSObject

- (NSArray *)coordinates;
- (void)addCoordinate:(CLLocationCoordinate2D)coordinate;

@end

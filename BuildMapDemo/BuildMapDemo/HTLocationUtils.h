//
//  LocationUtils.h
//  BuildMapDemo
//
//  Created by yangzexin on 8/20/13.
//  Copyright (c) 2013 hanting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface HTLocationUtils : NSObject

+ (CGSize)viewportSizeWithNorthEastCoordinate:(CLLocationCoordinate2D)northEastCoordinate southWestCoordinate:(CLLocationCoordinate2D)southWestCoordinate;
+ (double)distanceFromCoordinate:(CLLocationCoordinate2D)fromCoordinate toCoordinate:(CLLocationCoordinate2D)toCoordinate;
+ (double)horizontalDistanceFromCoordinate:(CLLocationCoordinate2D)fromCoordinate toCoordinate:(CLLocationCoordinate2D)toCoordinate;
+ (double)verticalDistanceFromCoordinate:(CLLocationCoordinate2D)fromCoordinate toCoordinate:(CLLocationCoordinate2D)toCoordinate;
+ (BOOL)isContainsCoordinate:(CLLocationCoordinate2D)coordinate northEastCoordinate:(CLLocationCoordinate2D)northEastCoordinate southWestCoordinate:(CLLocationCoordinate2D)southWestCoordinate;

@end

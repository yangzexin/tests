//
//  LocationUtils.m
//  BuildMapDemo
//
//  Created by yangzexin on 8/20/13.
//  Copyright (c) 2013 hanting. All rights reserved.
//

#import "HTLocationUtils.h"

@implementation HTLocationUtils

+ (double)distanceFromCoordinate:(CLLocationCoordinate2D)fromCoordinate toCoordinate:(CLLocationCoordinate2D)toCoordinate
{
    CLLocation *fromLocation = [[[CLLocation alloc] initWithLatitude:fromCoordinate.latitude longitude:fromCoordinate.longitude] autorelease];
    CLLocation *toLocation = [[[CLLocation alloc] initWithLatitude:toCoordinate.latitude longitude:toCoordinate.longitude] autorelease];
    
    return [fromLocation distanceFromLocation:toLocation];
}

+ (CGSize)viewportSizeWithNorthEastCoordinate:(CLLocationCoordinate2D)northEastCoordinate southWestCoordinate:(CLLocationCoordinate2D)southWestCoordinate
{
    CGFloat width = [self horizontalDistanceFromCoordinate:northEastCoordinate toCoordinate:southWestCoordinate];
    CGFloat height = [self verticalDistanceFromCoordinate:northEastCoordinate toCoordinate:southWestCoordinate];
    return CGSizeMake(width, height);
}

+ (double)verticalDistanceFromCoordinate:(CLLocationCoordinate2D)fromCoordinate toCoordinate:(CLLocationCoordinate2D)toCoordinate
{
    toCoordinate = CLLocationCoordinate2DMake(toCoordinate.latitude, fromCoordinate.longitude);
    double distance = [self distanceFromCoordinate:fromCoordinate toCoordinate:toCoordinate];
    return distance;
}

+ (double)horizontalDistanceFromCoordinate:(CLLocationCoordinate2D)fromCoordinate toCoordinate:(CLLocationCoordinate2D)toCoordinate
{
    toCoordinate = CLLocationCoordinate2DMake(fromCoordinate.latitude, toCoordinate.longitude);
    double distance = [self distanceFromCoordinate:fromCoordinate toCoordinate:toCoordinate];
    return distance;
}

+ (BOOL)isContainsCoordinate:(CLLocationCoordinate2D)coordinate northEastCoordinate:(CLLocationCoordinate2D)northEastCoordinate southWestCoordinate:(CLLocationCoordinate2D)southWestCoordinate
{
    return coordinate.latitude < northEastCoordinate.latitude && coordinate.longitude < northEastCoordinate.longitude && coordinate.latitude > southWestCoordinate.latitude && coordinate.longitude > southWestCoordinate.longitude;
}

@end

//
//  HTBuildingMapView.h
//  BuildMapDemo
//
//  Created by yangzexin on 8/16/13.
//  Copyright (c) 2013 hanting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface HTBuildingMapView : UIView

@property (nonatomic, assign) NSInteger zoomLevel;
@property (nonatomic, copy) void(^mapViewDidLoadComplete)();
@property (nonatomic, assign, readonly) CLLocationCoordinate2D mapNorthEastCoordinate;
@property (nonatomic, assign, readonly) CLLocationCoordinate2D mapSouthWestCoordinate;

- (void)setBuildingWithImage:(UIImage *)image northEastCoordinate:(CLLocationCoordinate2D)northEastCoordinate southWestCoordinate:(CLLocationCoordinate2D)southWestCoordinate;
- (void)setDrawableBlocks:(NSArray *)drawableBlocks;

@end

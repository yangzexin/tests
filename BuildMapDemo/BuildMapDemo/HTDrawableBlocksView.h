//
//  HTDrawableBlocksView.h
//  BuildMapDemo
//
//  Created by yangzexin on 8/20/13.
//  Copyright (c) 2013 hanting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface HTDrawableBlocksView : UIView

@property (nonatomic, retain) UIColor *blockColor;

- (void)setDrawableBlocks:(NSArray *)drawableBlocks northEastCoordinate:(CLLocationCoordinate2D)northEastCoordinate southWestCoordinate:(CLLocationCoordinate2D)southWestCoordinate;

@end

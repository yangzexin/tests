//
//  HTDrawableBlock.m
//  BuildMapDemo
//
//  Created by yangzexin on 8/20/13.
//  Copyright (c) 2013 hanting. All rights reserved.
//

#import "HTDrawableBlock.h"
#import <MapKit/MapKit.h>

@interface HTDrawableBlock ()

@property (nonatomic, retain) NSMutableArray *coordinates;

@end

@implementation HTDrawableBlock

- (void)dealloc
{
    [_coordinates release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    _coordinates = [[NSMutableArray array] retain];
    
    return self;
}

- (void)addCoordinate:(CLLocationCoordinate2D)coordinate
{
    [_coordinates addObject:[NSValue valueWithMKCoordinate:coordinate]];
}

@end

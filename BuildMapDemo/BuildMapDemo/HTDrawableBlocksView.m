//
//  HTDrawableBlocksView.m
//  BuildMapDemo
//
//  Created by yangzexin on 8/20/13.
//  Copyright (c) 2013 hanting. All rights reserved.
//

#import "HTDrawableBlocksView.h"
#import "HTDrawableBlock.h"
#import <MapKit/MapKit.h>
#import "HTLocationUtils.h"

@interface HTDrawableBlocksView ()

@property (nonatomic, retain) NSArray *drawableBlocks;
@property (nonatomic, assign) CLLocationCoordinate2D northEastCoordinate;
@property (nonatomic, assign) CLLocationCoordinate2D southWestCoordinate;

@end

@implementation HTDrawableBlocksView

- (void)dealloc
{
    self.drawableBlocks = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor clearColor];
    self.blockColor = [UIColor colorWithRed:0 green:0 blue:1.0f alpha:0.70f];
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for(HTDrawableBlock *block in self.drawableBlocks){
        NSArray *points = [self toAdjustedPointsWithDrawableBlock:block];
        CGContextBeginPath(context);
        if(points.count != 0){
            CGPoint firstPoint = [[points objectAtIndex:0] CGPointValue];
            CGContextMoveToPoint(context, firstPoint.x, firstPoint.y);
        }
        for(NSInteger i = 0; i < points.count; ++i){
            CGPoint point = [[points objectAtIndex:i] CGPointValue];
            CGContextAddLineToPoint(context, point.x, point.y);
        }
        CGContextClosePath(context);
        CGContextSetFillColorWithColor(context, self.blockColor.CGColor);
        CGContextDrawPath(context, kCGPathFill);
    }
}

#pragma mark - private methods
- (NSArray *)toAdjustedPointsWithDrawableBlock:(HTDrawableBlock *)block
{
    CGSize viewportSize = [HTLocationUtils viewportSizeWithNorthEastCoordinate:self.northEastCoordinate southWestCoordinate:self.southWestCoordinate];
    NSMutableArray *points = [NSMutableArray array];
    for(NSValue *value in [block coordinates]){
        CLLocationCoordinate2D coordinate = [value MKCoordinateValue];
        double top = [HTLocationUtils verticalDistanceFromCoordinate:self.northEastCoordinate toCoordinate:coordinate];
        double left = [HTLocationUtils horizontalDistanceFromCoordinate:self.southWestCoordinate toCoordinate:coordinate];
        
        double leftPercent = left / viewportSize.width;
        double topPercent = top / viewportSize.height;
        if(coordinate.latitude > self.northEastCoordinate.latitude){
            topPercent = -topPercent;
        }
        if(coordinate.longitude < self.southWestCoordinate.longitude){
            leftPercent = -leftPercent;
        }
        [points addObject:[NSValue valueWithCGPoint:CGPointMake(leftPercent * self.frame.size.width, topPercent * self.frame.size.height)]];
    }
    return points;
}

#pragma mark - instance methods
- (void)setDrawableBlocks:(NSArray *)drawableBlocks northEastCoordinate:(CLLocationCoordinate2D)northEastCoordinate southWestCoordinate:(CLLocationCoordinate2D)southWestCoordinate
{
    self.drawableBlocks = drawableBlocks;
    self.northEastCoordinate = northEastCoordinate;
    self.southWestCoordinate = southWestCoordinate;
    [self setNeedsDisplay];
}

@end

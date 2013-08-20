//
//  HTBuildingMapView.m
//  BuildMapDemo
//
//  Created by yangzexin on 8/16/13.
//  Copyright (c) 2013 hanting. All rights reserved.
//

#import "HTBuildingMapView.h"
#import <MapKit/MapKit.h>
#import "HTLocationUtils.h"
#import "HTDrawableBlocksView.h"

#define kMapLoadError               @"MAP_LOAD_ERROR"
#define kMapLoadStart               @"MAP_LOAD_START"
#define kMapLoadComplete            @"MAP_LOAD_COMPLETE"

#define kDefaultMapViewZoomLevel    20

@interface HTBuildingMapView () <UIWebViewDelegate>

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, assign) CLLocationCoordinate2D buildingNorthEastCoordinate;
@property (nonatomic, assign) CLLocationCoordinate2D buildingSouthWestCoordinate;
@property (nonatomic, assign) CGSize imageDisplaySize;
@property (nonatomic, retain) HTDrawableBlocksView *blocksView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation HTBuildingMapView

- (void)dealloc
{
    self.webView = nil;
    self.imageView = nil;
    self.blocksView = nil;
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    [self initialize];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
 
    [self initialize];
    
    return self;
}

- (void)initialize
{
    self.webView = [[[UIWebView alloc] initWithFrame:self.bounds] autorelease];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.webView.delegate = self;
    self.webView.userInteractionEnabled = NO;
    [self addSubview:self.webView];
    
    self.imageView = [[UIImageView new] autorelease];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.hidden = YES;
    self.imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.imageView];
    
    self.blocksView = [[[HTDrawableBlocksView alloc] initWithFrame:self.bounds] autorelease];
    self.blocksView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.blocksView];
    
    self.activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithFrame:self.bounds] autorelease];
    self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.activityIndicatorView.color = [UIColor blackColor];
    [self addSubview:self.activityIndicatorView];
    
    self.zoomLevel = kDefaultMapViewZoomLevel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - private methods
- (double)distanceFromCoordinate:(CLLocationCoordinate2D)fromCoordinate toCoordinate:(CLLocationCoordinate2D)toCoordinate
{
    return [HTLocationUtils distanceFromCoordinate:fromCoordinate toCoordinate:toCoordinate];
}

- (CGSize)viewportSizeWithNorthEastCoordinate:(CLLocationCoordinate2D)northEastCoordinate southWestCoordinate:(CLLocationCoordinate2D)southWestCoordinate
{
    return [HTLocationUtils viewportSizeWithNorthEastCoordinate:northEastCoordinate southWestCoordinate:southWestCoordinate];
}

- (void)handleJavascriptCommand:(NSString *)command
{
    if([command isEqualToString:kMapLoadError]){
        [self.activityIndicatorView stopAnimating];
    }else if([command isEqualToString:kMapLoadStart]){
        self.imageView.hidden = YES;
        self.blocksView.hidden = YES;
        [self.activityIndicatorView startAnimating];
    }else if([command hasPrefix:kMapLoadComplete]){
        [self.activityIndicatorView stopAnimating];
        
        command = [command substringFromIndex:kMapLoadComplete.length];
        
        NSArray *values = [command componentsSeparatedByString:@")("];
        NSString *northEastString = [values objectAtIndex:0];
        NSString *southWestString = [values objectAtIndex:1];
        northEastString = [northEastString stringByReplacingOccurrencesOfString:@"(" withString:@""];
        southWestString = [southWestString stringByReplacingOccurrencesOfString:@")" withString:@""];
        
        NSArray *northEastCoordinateValues = [northEastString componentsSeparatedByString:@","];
        NSArray *southWestCoordinateValues = [southWestString componentsSeparatedByString:@","];
        
        CLLocationCoordinate2D northEastCoordinate = CLLocationCoordinate2DMake([[northEastCoordinateValues objectAtIndex:0] doubleValue],
                                                                                [[northEastCoordinateValues objectAtIndex:1] doubleValue]);
        CLLocationCoordinate2D southWestCoordinate = CLLocationCoordinate2DMake([[southWestCoordinateValues objectAtIndex:0] doubleValue],
                                                                                [[southWestCoordinateValues objectAtIndex:1] doubleValue]);
        
        _mapNorthEastCoordinate = northEastCoordinate;
        _mapSouthWestCoordinate = southWestCoordinate;
        
        CGSize mapViewPortSize = [self viewportSizeWithNorthEastCoordinate:northEastCoordinate southWestCoordinate:southWestCoordinate];
        CGFloat imageDisplayTop = [HTLocationUtils verticalDistanceFromCoordinate:northEastCoordinate toCoordinate:self.buildingNorthEastCoordinate];
        CGFloat imageDisplayLeft = [HTLocationUtils horizontalDistanceFromCoordinate:southWestCoordinate toCoordinate:self.buildingSouthWestCoordinate];
        CGFloat topPercent = imageDisplayTop / mapViewPortSize.height;
        CGFloat leftPercent = imageDisplayLeft / mapViewPortSize.width;
        CGFloat widthPercent = self.imageDisplaySize.width / mapViewPortSize.width;
        CGFloat heightPercent = self.imageDisplaySize.height / mapViewPortSize.height;
        self.imageView.frame = CGRectMake(leftPercent * self.frame.size.width, topPercent * self.frame.size.height, widthPercent * self.frame.size.width, heightPercent * self.frame.size.height);
        
        self.imageView.alpha = 0.0f;
        self.imageView.hidden = NO;
        [UIView animateWithDuration:0.30f animations:^{
            self.imageView.alpha = 1.0f;
        }];
        
        if(self.mapViewDidLoadComplete){
            self.mapViewDidLoadComplete();
        }
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *URLString = [request.URL absoluteString];
    if([URLString hasPrefix:@"cmd://"]){
        NSString *cmd = [URLString substringFromIndex:6];
        [self handleJavascriptCommand:cmd];
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self handleJavascriptCommand:kMapLoadError];
}

#pragma mark - instance methods
- (void)setZoomLevel:(NSInteger)zoomLevel
{
    _zoomLevel = zoomLevel;
    if(self.imageView.image){
        [self setBuildingWithImage:self.imageView.image northEastCoordinate:self.buildingNorthEastCoordinate southWestCoordinate:self.buildingSouthWestCoordinate];
    }
}

- (void)setBuildingWithImage:(UIImage *)image northEastCoordinate:(CLLocationCoordinate2D)northEastCoordinate southWestCoordinate:(CLLocationCoordinate2D)southWestCoordinate
{
    self.imageView.image = image;
    NSString *html = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"googleMap" ofType:@"html"]
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];
    self.buildingNorthEastCoordinate = northEastCoordinate;
    self.buildingSouthWestCoordinate = southWestCoordinate;
    self.imageDisplaySize = [self viewportSizeWithNorthEastCoordinate:northEastCoordinate southWestCoordinate:southWestCoordinate];
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((southWestCoordinate.latitude + northEastCoordinate.latitude) / 2, (southWestCoordinate.longitude + northEastCoordinate.longitude) / 2);
    
    html = [html stringByReplacingOccurrencesOfString:@"$latitude" withString:[NSString stringWithFormat:@"%f", center.latitude]];
    html = [html stringByReplacingOccurrencesOfString:@"$longitide" withString:[NSString stringWithFormat:@"%f", center.longitude]];
    html = [html stringByReplacingOccurrencesOfString:@"$zoom" withString:[NSString stringWithFormat:@"%d", self.zoomLevel]];
    [self.webView loadHTMLString:html baseURL:nil];
    
}

- (void)setDrawableBlocks:(NSArray *)drawableBlocks
{
    [self.blocksView setDrawableBlocks:drawableBlocks northEastCoordinate:self.mapNorthEastCoordinate southWestCoordinate:self.mapSouthWestCoordinate];
    self.blocksView.alpha = 0.0f;
    self.blocksView.hidden = NO;
    [UIView animateWithDuration:0.30f animations:^{
        self.blocksView.alpha = 1.0f;
    }];
}

@end

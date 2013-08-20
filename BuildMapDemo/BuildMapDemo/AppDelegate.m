//
//  AppDelegate.m
//  BuildMapDemo
//
//  Created by yangzexin on 8/16/13.
//  Copyright (c) 2013 hanting. All rights reserved.
//

#import "AppDelegate.h"
#import "HTBuildingMapView.h"
#import "HTDrawableBlocksView.h"
#import "HTDrawableBlock.h"

@interface AppDelegate ()

@property (nonatomic, retain) HTBuildingMapView *mapView;

@end

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    self.mapView = [[[HTBuildingMapView alloc] initWithFrame:CGRectMake(0, 20, screenBounds.size.width, screenBounds.size.height - 20)] autorelease];
    self.mapView.zoomLevel = 19;
    [self.mapView setBuildingWithImage:[UIImage imageNamed:@"A-floor-5-min.fw.png"]
                   northEastCoordinate:CLLocationCoordinate2DMake(31.191497,121.375091)
                   southWestCoordinate:CLLocationCoordinate2DMake(31.190827,121.374587)];
    [self.window addSubview:self.mapView];
    
    __block typeof(self) bself = self;
    [self.mapView setMapViewDidLoadComplete:^{
        [bself.mapView setDrawableBlocks:[bself blocksForTest]];
    }];
    
    return YES;
}

- (NSArray *)blocksForTest
{
    NSMutableArray *blocks = [NSMutableArray array];
    HTDrawableBlock *block = nil;
    
    block = [[HTDrawableBlock new] autorelease];
    [block addCoordinate:CLLocationCoordinate2DMake(31.190926,121.376642)];
    [block addCoordinate:CLLocationCoordinate2DMake(31.190678,121.376094)];
    [block addCoordinate:CLLocationCoordinate2DMake(31.191266,121.375716)];
    [block addCoordinate:CLLocationCoordinate2DMake(31.191541,121.376245)];
    [blocks addObject:block];
    
    block = [[HTDrawableBlock new] autorelease];
    [block addCoordinate:CLLocationCoordinate2DMake(31.191346,121.374136)];
    [block addCoordinate:CLLocationCoordinate2DMake(31.191474,121.374461)];
    [block addCoordinate:CLLocationCoordinate2DMake(31.191603,121.374399)];
    [block addCoordinate:CLLocationCoordinate2DMake(31.191491,121.374056)];
    [blocks addObject:block];
    
    block = [[HTDrawableBlock new] autorelease];
    [block addCoordinate:CLLocationCoordinate2DMake(31.191491,121.374523)];
    [block addCoordinate:CLLocationCoordinate2DMake(31.191546,121.374643)];
    [block addCoordinate:CLLocationCoordinate2DMake(31.191688,121.374735)];
    [block addCoordinate:CLLocationCoordinate2DMake(31.191775,121.374726)];
    [block addCoordinate:CLLocationCoordinate2DMake(31.191917,121.37463)];
    [block addCoordinate:CLLocationCoordinate2DMake(31.191904,121.374574)];
    [block addCoordinate:CLLocationCoordinate2DMake(31.191803,121.374627)];
    [block addCoordinate:CLLocationCoordinate2DMake(31.191681,121.37459)];
    [block addCoordinate:CLLocationCoordinate2DMake(31.191578,121.374464)];
    [blocks addObject:block];
    
    return blocks;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

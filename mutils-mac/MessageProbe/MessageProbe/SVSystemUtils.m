//
//  SVSystemUtils.m
//  MessageSlave
//
//  Created by yangzexin on 6/9/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import "SVSystemUtils.h"

@implementation SVSystemUtils

NSColor *SVCGColorOfScreenPixel(CGDirectDisplayID displayID, NSInteger x, NSInteger y) {
    CGImageRef image = CGDisplayCreateImageForRect(displayID, CGRectMake(x, y, 1, 1));
    NSBitmapImageRep *bitmap = [[[NSBitmapImageRep alloc] initWithCGImage:image] autorelease];
    CGImageRelease(image);
    NSColor *color = [bitmap colorAtX:0 y:0];
    return color;
}

+ (NSColor *)colorOfScreenPixelAtPoint:(CGPoint)point
{
    NSDictionary *screenDictionary = [[NSScreen mainScreen] deviceDescription];
    NSNumber *screenID = [screenDictionary objectForKey:@"NSScreenNumber"];
    CGDirectDisplayID displayID = [screenID unsignedIntValue];
    NSColor *color = SVCGColorOfScreenPixel(displayID, point.x, point.y);
    return color;
}

@end

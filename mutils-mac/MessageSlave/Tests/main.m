//
//  main.m
//  Tests
//
//  Created by yangzexin on 5/29/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

NSArray *GetNumberIntervals()
{
    NSMutableArray *numberIntervals = [NSMutableArray array];
    NSString *numbers = @"18601601860161186016218601631860164186016518601661860167186016818601691860170186017118601721860173186017418601751860176186017718601781860179186021018602111860212186021318602141860215186021618602171860218186021918621001862101186210218621031862104186210518621061862107186210818621091862110186211118621121862113186211418621151862116186211718621181862119186212018621211862122186212318621241862125186212618621271862128186212918621301862131186213218621331862134186213518621361862137186213818621391862140186214118621421862143186214418621451862146186214718621481862149186215018621511862152186215318621541862155186215618621571862158186215918621601862161186216218621631862164186216518621661862167186216818621691862170186217118621721862173186217418621751862176186217718621781862179";
    for(NSInteger i = 0; i <= numbers.length - 7; i += 7){
        NSString *numberInterval = [numbers substringWithRange:NSMakeRange(i, 7)];
        [numberIntervals addObject:numberInterval];
    }
    return numberIntervals;
}

NSString *GenerateNumbersWithInterval(NSString *numberInterval, NSString *filePath)
{
    NSMutableString *allNumbers = [NSMutableString string];
    for(NSInteger i = 0; i < 10000; ++i){
        NSString *tmpNumber = [NSString stringWithFormat:@"%@%04ld", numberInterval, i];
        [allNumbers appendFormat:@"%@\n", tmpNumber];
    }
    if(filePath.length != 0){
        [allNumbers writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
    }
    return allNumbers;
}

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        NSArray *numberIntervals = GetNumberIntervals();
        NSString *parentPath = @"/Users/yangzexin/Downloads/";
        NSMutableString *allNumbers = [NSMutableString string];
        for(NSString *numberInterval in numberIntervals){
            NSString *numbers = GenerateNumbersWithInterval(numberInterval, nil);
            [allNumbers appendFormat:@"%@", numbers];
        }
        [allNumbers writeToFile:[parentPath stringByAppendingPathComponent:@"numbers.txt"] atomically:NO encoding:NSUTF8StringEncoding error:nil];
    }
    return 0;
}

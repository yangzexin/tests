//
//  main.m
//  ScriptEncrypter
//
//  Created by yangzexin on 13-5-22.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVCodeUtils.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // insert code here...
        NSLog(@"Hello, World!");
        NSString *path = @"/Users/yangzexin/Downloads/script_encrypted";
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
        for(NSString *fileName in files){
            NSLog(@"%@", fileName);
            NSString *newFileName = [NSString stringWithFormat:@"%@_.%@", [fileName stringByDeletingPathExtension], [fileName pathExtension]];
            NSString *newFileNamePath = [path stringByAppendingPathComponent:newFileName];
            NSString *script = [NSString stringWithContentsOfFile:[path stringByAppendingPathComponent:fileName] encoding:NSUTF8StringEncoding error:nil];
            [[SVCodeUtils encodeWithString:script] writeToFile:newFileNamePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
        }
    }
    return 0;
}


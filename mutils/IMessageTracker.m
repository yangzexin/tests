//
//  IMessageTracker.m
//  mtracker
//
//  Created by yangzexin on 13-6-24.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "IMessageTracker.h"
#import "sqlite3.h"

@implementation IMessageTracker

+ (BOOL)isIMessageSentWithNumber:(NSString *)number date:(NSTimeInterval)date error:(NSError **)error
{
    /**
     date为通过xpc调用Messages发送短信的时间，Messages发送成功之后，纪录相关结果到sms.db中，所以Messages纪录的时间是一定大于date的
     */
    BOOL success = NO;
    
    const int timeoutInterval = 5;
    const int maxTryCount = 20;
    const NSTimeInterval sleepInterval = ((NSTimeInterval)timeoutInterval) / maxTryCount;
    int tryCount = 0;
    
    NSString *smsDbPath = @"/var/mobile/Library/SMS/sms.db";
    
    sqlite3 *dbHandler = nil;
    if(sqlite3_open([smsDbPath UTF8String], &dbHandler) == SQLITE_OK){
        NSString *sql = [NSString stringWithFormat:@"select madrid_error from message where madrid_handle='%@' and date>=%d and date<=%d and madrid_date_delivered <> 0", number, (int)date, (int)date + timeoutInterval];
        while(YES){
            sqlite3_stmt *stmt = nil;
            const char *pzTail = nil;
            NSLog(@"checking with sql:%@", sql);
            if(sqlite3_prepare(dbHandler, [sql UTF8String], -1, &stmt, &pzTail) == SQLITE_OK){
                if(sqlite3_step(stmt) == SQLITE_ROW){
                    int madrid_error = sqlite3_column_int(stmt, 0);
                    NSLog(@"madrid_error:%d", madrid_error);
                    success = madrid_error == 0;
                    NSLog(@"data checked, message sent:%@", success ? @"success" : @"failure");
                    break;
                }else{
                    NSLog(@"no data");
                }
            }else{
                NSLog(@"stmt error:%s", pzTail);
            }
            [NSThread sleepForTimeInterval:sleepInterval];
            sqlite3_finalize(stmt);
            
            if(++tryCount == maxTryCount){
                *error = [NSError errorWithDomain:@"" code:-2 userInfo:[NSDictionary dictionaryWithObject:@"check time out" forKey:NSLocalizedDescriptionKey]];
                break;
            }
        }
    }else{
        *error = [NSError errorWithDomain:@"" code:-1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"cannot open database at path:%@", smsDbPath] forKey:NSLocalizedDescriptionKey]];
    }
    sqlite3_close(dbHandler);
    
    return success;
}

@end

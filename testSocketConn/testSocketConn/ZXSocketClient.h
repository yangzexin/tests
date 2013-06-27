//
//  ZXSocket.h
//  testSocketConn
//
//  Created by yangzexin on 13-6-26.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXSocketClient : NSObject

@property(nonatomic, readonly)NSInputStream *inputStream;
@property(nonatomic, readonly)NSOutputStream *outputStream;
@property(nonatomic, readonly, getter = isConnected)BOOL connected;

@property(nonatomic, copy)void(^availableBytesHandler)();

- (id)initWithHost:(NSString *)host port:(int)port;
- (void)connect;
- (void)disconnect;

@end

@interface ZXSocketClient (CommonUtils)

- (void)writeWithUTF8String:(NSString *)string;
- (void)writeWithString:(NSString *)string encoding:(NSStringEncoding)encoding;

- (NSString *)readUTF8String;
- (NSString *)readStringWithEncoding:(NSStringEncoding)encoding;

@end
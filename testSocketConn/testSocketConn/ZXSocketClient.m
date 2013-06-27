//
//  ZXSocket.m
//  testSocketConn
//
//  Created by yangzexin on 13-6-26.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "ZXSocketClient.h"

@interface ZXSocketClient () <NSStreamDelegate>

@property(nonatomic, copy)NSString *host;
@property(nonatomic, assign)int port;
@property(nonatomic, assign)BOOL connected;
@property(nonatomic, assign)BOOL errored;
@property(nonatomic, assign)BOOL inputStreamOpened;
@property(nonatomic, assign)BOOL outputStreamOpened;

@property(nonatomic, retain)NSInputStream *inputStream;
@property(nonatomic, retain)NSOutputStream *outputStream;

@end

@implementation ZXSocketClient

- (void)dealloc
{
    [self disconnect];
    self.host = nil;
    self.inputStream = nil;
    self.outputStream = nil;
    self.availableBytesHandler = nil;
    [super dealloc];
}

- (id)initWithHost:(NSString *)host port:(int)port
{
    self = [super init];
    
    self.host = host;
    self.port = port;
    
    return self;
}

- (void)connect
{
    CFReadStreamRef readStream = NULL;
    CFWriteStreamRef writeStream = NULL;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)self.host, self.port, &readStream, &writeStream);
    if(readStream && writeStream){
        self.inputStream = (NSInputStream *)readStream;
        self.outputStream = (NSOutputStream *)writeStream;
        
        self.inputStream.delegate = self;
        self.outputStream.delegate = self;
        
        [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.inputStream open];
        [self.outputStream open];
        while(!self.connected && !self.errored){
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    if(eventCode == NSStreamEventOpenCompleted){
        NSLog(@"open completed:%@", aStream);
        if(aStream == self.inputStream){
            self.inputStreamOpened = YES;
        }else if(aStream == self.outputStream){
            self.outputStreamOpened = YES;
        }
        if(self.inputStreamOpened && self.outputStreamOpened){
            self.connected = YES;
            NSLog(@"connected:%@", self.host);
        }
    }else if(eventCode == NSStreamEventErrorOccurred){
        NSLog(@"error occurred:%@", aStream);
        self.errored = YES;
    }else if(eventCode == NSStreamEventEndEncountered){
        NSLog(@"end encountered:%@", aStream);
    }else if(eventCode == NSStreamEventHasBytesAvailable){
        NSLog(@"has bytes available:%@", aStream);
        if(self.availableBytesHandler){
            self.availableBytesHandler();
        }
    }else if(eventCode == NSStreamEventHasSpaceAvailable){
        NSLog(@"has space available:%@", aStream);
    }
}

- (void)disconnect
{
    [self.inputStream close];
    [self.outputStream close];
}

- (void)writeWithUTF8String:(NSString *)string
{
    [self writeWithString:string encoding:NSUTF8StringEncoding];
}

- (void)writeWithString:(NSString *)string encoding:(NSStringEncoding)encoding
{
    NSData *data = [string dataUsingEncoding:encoding];
    NSOutputStream *outputStream = self.outputStream;
    [self writeInt:data.length];
    [outputStream write:[data bytes] maxLength:data.length];
}

- (NSString *)readUTF8String
{
    return [self readStringWithEncoding:NSUTF8StringEncoding];
}

- (NSString *)readStringWithEncoding:(NSStringEncoding)encoding
{
    NSInputStream *inputStream = self.inputStream;
    NSInteger contentLength = [self readInt];
    if(contentLength > 0){
        uint8_t *buffer = malloc(sizeof(uint8_t) * contentLength);
        [inputStream read:buffer maxLength:contentLength];
        NSString *string = [[[NSString alloc] initWithData:[NSData dataWithBytes:buffer length:contentLength] encoding:encoding] autorelease];
        free(buffer);
        return string;
    }
    return nil;
}

- (void)writeInt:(int)i
{
    uint8_t *temp = malloc(sizeof(uint8_t) * 4);
    *temp = (i & 0xff000000) >> 24;
    *(temp + 1) = (i & 0xff0000) >> 16;
    *(temp + 2) = (i & 0xff00) >> 8;
    *(temp + 3) = i & 0xff;
    [self.outputStream write:temp maxLength:4];
}

- (int)readInt
{
    uint8_t buff[4];
    [self.inputStream read:buff maxLength:4];
    return ((buff[0] << 24) & 0xff000000) + ((buff[1] << 16) & 0xff0000) + ((buff[2] << 8) & 0xff00) + (buff[3] & 0xff);
}

@end

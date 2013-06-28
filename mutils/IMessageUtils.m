//
//  IMessageUtils.m
//  
//
//  Created by yangzexin on 13-6-28.
//
//

#import "IMessageUtils.h"
#import <xpc/xpc.h>
#import "IMessageTracker.h"

@implementation IMessageUtils

+ (BOOL)sendIMessageWithRecipient:(NSString *)recipient text:(NSString *)text error:(NSError **)error
{
    NSTimeInterval startDate = [NSDate timeIntervalSinceReferenceDate];
    
    xpc_connection_t myconnection;
    
    dispatch_queue_t queue = dispatch_queue_create("com.apple.chatkit.clientcomposeserver.xpc", DISPATCH_QUEUE_CONCURRENT);
    
    myconnection = xpc_connection_create_mach_service("com.apple.chatkit.clientcomposeserver.xpc", queue, XPC_CONNECTION_MACH_SERVICE_PRIVILEGED);
    
    xpc_connection_set_event_handler(myconnection, ^(xpc_object_t event){
        xpc_type_t xtype = xpc_get_type(event);
        if(XPC_TYPE_ERROR == xtype){
            NSLog(@"XPC sandbox connection error: %s\n", xpc_dictionary_get_string(event, XPC_ERROR_KEY_DESCRIPTION));
        }
        NSLog(@"Received an message event!");
    });
    
    xpc_connection_resume(myconnection);
    
    NSData *ser_rec = [NSPropertyListSerialization dataWithPropertyList:[NSArray arrayWithObject:recipient] format:200 options:0 error:NULL];
    
    xpc_object_t mydict = xpc_dictionary_create(0, 0, 0);
    xpc_dictionary_set_int64(mydict, "message-type", 0);
    xpc_dictionary_set_data(mydict, "recipients", [ser_rec bytes], [ser_rec length]);
    xpc_dictionary_set_string(mydict, "text", [text UTF8String]);
    
    xpc_connection_send_message(myconnection, mydict);
    xpc_connection_send_barrier(myconnection, ^{
        NSLog(@"Message has been successfully delievered");
    });
    
    BOOL success = [IMessageTracker isIMessageSentWithNumber:recipient date:startDate error:error];
    
    return success;
}

@end

//
//  IMessageService.m
//  
//
//  Created by yangzexin on 13-7-1.
//
//

#import "IMessageCenter.h"
#import "IMessageUtils.h"

@interface IMessageCenter ()

@property(nonatomic, retain)NSOperationQueue *operationQueue;

@end

@implementation IMessageCenter

@synthesize messageResultHandler;
@synthesize operationQueue;

+ (id)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)dealloc
{
    [self cancelAll];
    self.operationQueue = nil;
    self.messageResultHandler = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.operationQueue = [[NSOperationQueue new] autorelease];
    
    return self;
}

- (void)sendMessageWithRecipient:(NSString *)recipient text:(NSString *)text
{
    [self.operationQueue addOperationWithBlock:^{
        BOOL success = [IMessageUtils sendIMessageWithRecipient:recipient text:text error:nil];
        if(self.messageResultHandler){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.messageResultHandler(success, recipient, text);
            });
        }
    }];
}

- (void)cancelAll
{
    [self.operationQueue cancelAllOperations];
}

@end

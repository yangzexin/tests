//
//  IMessageService.h
//  
//
//  Created by yangzexin on 13-7-1.
//
//

#import <UIKit/UIKit.h>

@interface IMessageCenter : NSObject

@property(nonatomic, copy)void(^messageResultHandler)(BOOL success, NSString *recipient, NSString *text);

+ (id)sharedInstance;

- (void)sendMessageWithRecipient:(NSString *)recipient text:(NSString *)text;
- (void)cancelAll;

@end

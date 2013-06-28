//
//  IMessageUtils.h
//  
//
//  Created by yangzexin on 13-6-28.
//
//

#import <UIKit/UIKit.h>

@interface IMessageUtils : NSObject

+ (BOOL)sendIMessageWithRecipient:(NSString *)recipient text:(NSString *)text error:(NSError **)error;

@end

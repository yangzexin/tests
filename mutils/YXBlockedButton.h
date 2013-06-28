//
//  YXBlockedButton.h
//  
//
//  Created by yangzexin on 13-6-28.
//
//

#import <UIKit/UIKit.h>

@interface YXBlockedButton : UIView

@property(nonatomic, copy)void(^tapHandler)();
@property(nonatomic, readonly)UIButton *button;

+ (id)buttonWithType:(UIButtonType)buttonType;

@end

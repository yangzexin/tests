//
//  ImageEditor.h
//  ImageEditorTest
//
//  Created by yangzexin on 13-7-1.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YXImageLabel;

@interface YXImageEditor : UIScrollView <UIKeyInput>

@property(nonatomic, copy)NSString *imageLeftMatchingText;
@property(nonatomic, copy)NSString *imageRightMatchingText;

@property(nonatomic, copy)UIView *(^viewGetter)(NSString *imageName);
@property(nonatomic, copy)UIImage *(^imageGetter)(NSString *imageName);

@end

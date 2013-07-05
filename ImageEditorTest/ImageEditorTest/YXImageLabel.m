//
//  MsgLabel.m
//  Quartz2d_Learning
//
//  Created by yangzexin on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YXImageLabel.h"

NSString *kImageLabelDefaultImageLeftMatchingText = @"{IMG";
NSString *kImageLabelDefaultImageRightMatchingText = @"}";

@interface YXDrawBlock : NSObject

@property(nonatomic, assign)CGFloat x;
@property(nonatomic, assign)CGFloat y;
@property(nonatomic, assign)CGFloat width;
@property(nonatomic, assign)CGFloat height;
@property(nonatomic, retain)NSString *text;

@end

@implementation YXDrawBlock

- (void)dealloc
{
    self.text = nil;
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[%@, %f, %f, %f, %f]", self.text, self.x, self.y, self.width, self.height];
}

- (BOOL)hitTestPoint:(CGPoint)point
{
    return point.x >= self.x && point.x - self.width <= self.x && point.y >= self.y && point.y <= self.y + self.height;
}

+ (id)createWithText:(NSString *)text x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
{
    YXDrawBlock *block = [[YXDrawBlock new] autorelease];
    block.text = text;
    block.x = x;
    block.y = y;
    block.width = width;
    block.height = height;
    return block;
}

@end

@interface YXImageLabel ()

@property(nonatomic, assign)CGFloat realHeight;
@property(nonatomic, retain)NSMutableArray *addInSubviews;
@property(nonatomic, retain)NSMutableArray *textBlocks;

@end

@implementation YXImageLabel

- (void)dealloc
{
    self.text = nil;
    self.font = nil;
    self.textColor = nil;
    self.viewGetter = nil;
    self.imageGetter = nil;
    self.addInSubviews = nil;
    self.textBlocks = nil;
    [super dealloc];
}

- (id)init
{
    self = [self initWithFrame:CGRectZero];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.imageLeftMatchingText = kImageLabelDefaultImageLeftMatchingText;
    self.imageRightMatchingText = kImageLabelDefaultImageRightMatchingText;
    
    self.font = [UIFont systemFontOfSize:14.0f];
    self.backgroundColor = [UIColor clearColor];
    self.textColor = [UIColor blackColor];
    
    self.addInSubviews = [NSMutableArray array];
    
    return self;
}

- (UIView *)viewForImageName:(NSString *)imageName
{
    if(self.viewGetter){
        UIView *view = self.viewGetter(imageName);
        return view;
    }
    return nil;
}

- (void)drawRect:(CGRect)rect
{
    for(UIView *view in self.addInSubviews){
        [view removeFromSuperview];
    }
    [self drawTextWithRect:rect fakeDraw:NO text:self.text];
}

- (CGPoint)drawTextWithRect:(CGRect)rect fakeDraw:(BOOL)fakeDraw prepareTextBlocks:(BOOL)prepareTextBlocks text:(NSString *)text
{
    if(!text){
        self.realHeight = [self.font lineHeight];
        return CGPointMake(0, 0);
    }
    
    if(prepareTextBlocks){
        self.textBlocks = [NSMutableArray array];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if(!fakeDraw){
        CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
        CGContextFillRect(context, rect);
        CGContextSetFillColorWithColor(context, self.textColor.CGColor);
    }
    
    NSString *imageLeftMatching = self.imageLeftMatchingText;
    NSString *firstCh = [imageLeftMatching substringToIndex:1];
    NSString *imageRightMatching = self.imageRightMatchingText;
    CGFloat tmpX = 0.0f;
    CGFloat tmpY = 0.0f;
    CGFloat tmpLineHeight = self.font.lineHeight;
    for(NSInteger i = 0; i < text.length;){
        NSRange charRange = [text rangeOfComposedCharacterSequenceAtIndex:i];
        NSString *ch = [text substringWithRange:charRange];
        if([ch isEqualToString:firstCh]){
            if(i + imageLeftMatching.length < text.length){
                NSString *pp = [text substringWithRange:NSMakeRange(i, imageLeftMatching.length)];
                if([pp isEqualToString:imageLeftMatching]){
                    NSRange tmpRange = [text rangeOfString:imageRightMatching options:NSCaseInsensitiveSearch range:NSMakeRange(i, text.length - i)];
                    if(tmpRange.location != NSNotFound){
                        NSString *imageName = [text substringWithRange:NSMakeRange(i + imageLeftMatching.length, tmpRange.location - i - imageLeftMatching.length)];
                        
                        UIView *view = [self viewForImageName:imageName];
                        if(view){
                            if(!fakeDraw){
                                [self.addInSubviews addObject:view];
                            }
                            CGRect tmpRect = view.frame;
                            if(tmpX + tmpRect.size.width >= rect.size.width){
                                tmpY += tmpLineHeight;
                                tmpX = 0;
                            }
                            tmpRect.origin.x = tmpX;
                            tmpRect.origin.y = tmpY;
                            view.frame = tmpRect;
                            
                            tmpLineHeight = tmpRect.size.height > tmpLineHeight ? tmpRect.size.height : tmpLineHeight;
                            if(!fakeDraw){
                                [self addSubview:view];
                            }
                            if(prepareTextBlocks){
                                [self.textBlocks addObject:[YXDrawBlock createWithText:[NSString stringWithFormat:@"%@%@%@", kImageLabelDefaultImageLeftMatchingText, imageName, kImageLabelDefaultImageRightMatchingText]
                                                                                     x:tmpX
                                                                                     y:tmpY
                                                                                 width:tmpRect.size.width
                                                                                height:tmpLineHeight]];
                            }
                            
                            tmpX += tmpRect.size.width;
                            
                            i = tmpRange.location + 1;
                            continue;
                        }else{
                            UIImage *img = nil;
                            if(self.imageGetter){
                                img = self.imageGetter(imageName);
                            }else{
                                img = [UIImage imageNamed:imageName];
                            }
                            if(img){
                                if(tmpX + img.size.width >= rect.size.width){
                                    tmpY += tmpLineHeight;
                                    tmpX = 0;
                                }
                                
                                tmpLineHeight = img.size.height > tmpLineHeight ? img.size.height : tmpLineHeight;
                                
                                if(!fakeDraw){
                                    [img drawAtPoint:CGPointMake(tmpX, tmpY)];
                                }
                                if(prepareTextBlocks){
                                    [self.textBlocks addObject:[YXDrawBlock createWithText:[NSString stringWithFormat:@"%@%@%@", kImageLabelDefaultImageLeftMatchingText, imageName, kImageLabelDefaultImageRightMatchingText]
                                                                                         x:tmpX
                                                                                         y:tmpY
                                                                                     width:img.size.width
                                                                                    height:tmpLineHeight]];
                                }
                                tmpX += img.size.width;
                                
                                i = tmpRange.location + 1;
                                continue;
                            }
                        }
                    }
                }
            }
        }
        if([ch isEqualToString:@"\n"]){
            tmpX = 0;
            tmpY += tmpLineHeight;
            tmpLineHeight = self.font.lineHeight;
            if(prepareTextBlocks){
                [self.textBlocks addObject:[YXDrawBlock createWithText:ch x:tmpX y:tmpY width:1 height:tmpLineHeight]];
            }
        }else{
            CGFloat strWidth = [ch sizeWithFont:self.font].width;
            if(tmpX + strWidth > rect.size.width){
                tmpX = 0;
                tmpY += tmpLineHeight;
                tmpLineHeight = self.font.lineHeight;
            }
            if(!fakeDraw){
                [ch drawAtPoint:CGPointMake(tmpX, tmpY) withFont:self.font];
            }
            if(prepareTextBlocks){
                [self.textBlocks addObject:[YXDrawBlock createWithText:ch x:tmpX y:tmpY width:strWidth height:tmpLineHeight]];
            }
            tmpX += strWidth;
        }
        
        i = charRange.location + charRange.length;
    }
    
    CGPoint lastPosition = CGPointMake(tmpX, tmpY);
    self.realHeight = tmpY + tmpLineHeight;
    return lastPosition;
}

- (CGPoint)drawTextWithRect:(CGRect)rect fakeDraw:(BOOL)fakeDraw text:(NSString *)text
{
    return [self drawTextWithRect:rect fakeDraw:fakeDraw prepareTextBlocks:YES text:text];
}

- (void)setText:(NSString *)m
{
    if(_text != m){
        [_text release];
        _text = [m copy];
    }
    [self setNeedsDisplay];
}

- (void)resizeToSuitableHeight
{
    [self drawTextWithRect:self.bounds fakeDraw:YES text:self.text];
    CGRect rect = self.frame;
    rect.size.height = self.realHeight;
    self.frame = rect;
}

- (CGRect)caretRectAtIndex:(NSUInteger)index
{
    const CGFloat caretWidth = 3;
    if(index < self.textBlocks.count){
        YXDrawBlock *targetBlock = [self.textBlocks objectAtIndex:index];
        return CGRectMake(targetBlock.x, targetBlock.y + (self.font.lineHeight - (self.font.descender + self.font.ascender)) / 2, caretWidth, self.font.descender + self.font.ascender);
    }else{
        YXDrawBlock *targetBlock = [self.textBlocks lastObject];
        return CGRectMake(targetBlock.x + targetBlock.width, targetBlock.y + (self.font.lineHeight - (self.font.descender + self.font.ascender)) / 2, caretWidth, self.font.descender + self.font.ascender);
    }
}

- (NSUInteger)caretPositionAtPoint:(CGPoint)point
{
    NSInteger index = -1;
    if(self.textBlocks.count == 0){
        return 0;
    }
    for(NSInteger i = 0; i < self.textBlocks.count; ++i){
        YXDrawBlock *block = [self.textBlocks objectAtIndex:i];
        if([block hitTestPoint:point]){
            index = i;
            break;
        }
    }
    if(index == -1){
        index = self.textBlocks.count;
    }
    return index;
}

- (NSString *)charAtIndex:(NSInteger)index
{
    if(index < self.textBlocks.count){
        YXDrawBlock *block = [self.textBlocks objectAtIndex:index];
        return block.text;
    }
    return nil;
}

- (NSInteger)updatePositionForCaretPosition:(NSInteger)caretPosition
{
    NSInteger numOfChars = 0;
    for(NSInteger i = 0; i < self.textBlocks.count && i < caretPosition; ++i){
        YXDrawBlock *block = [self.textBlocks objectAtIndex:i];
        numOfChars += block.text.length;
    }
    return numOfChars;
}

- (NSInteger)numberOfDeleteCharsForCaretPosition:(NSInteger)caretPosition
{
    YXDrawBlock *block = [self.textBlocks objectAtIndex:caretPosition - 1];
    return block.text.length;
}

@end

//
//  ImageEditor.m
//  ImageEditorTest
//
//  Created by yangzexin on 13-7-1.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "ImageEditor.h"
#import "YXImageLabel.h"
#import "APLSimpleCaretView.h"

@interface ImageEditor () <UIKeyInput, UITextInput>

@property(nonatomic, retain)NSMutableString *text;
@property(nonatomic, retain)YXImageLabel *imageLabel;

@property (nonatomic) UITextInputStringTokenizer *tokenizer;

@property(nonatomic, retain)NSString *markingText;

@property(nonatomic, assign)NSUInteger caretPosition;
@property(nonatomic, retain)APLSimpleCaretView *caretView;

@end

@implementation ImageEditor

@synthesize inputDelegate;
@dynamic markedTextStyle;

- (void)dealloc
{
    self.text = nil;
    self.imageLabel = nil;
    self.tokenizer = nil;
    self.markingText = nil;
    self.caretView = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.caretPosition = 0;
    [self addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)] autorelease]];
    
    self.imageLabel = [[[YXImageLabel alloc] initWithFrame:self.bounds] autorelease];
    self.imageLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.imageLabel.userInteractionEnabled = NO;
    self.imageLabel.backgroundColor = [UIColor clearColor];
    self.imageLabel.font = [UIFont systemFontOfSize:18.0f];
    [self.imageLabel setViewGetter:^UIView *(NSString *imageName) {
        UIImageView *imgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_passbook.png"]] autorelease];
        imgView.frame = CGRectMake(0, 0, imgView.image.size.width, imgView.image.size.height);
        return imgView;
    }];
    [self addSubview:self.imageLabel];
    
    self.caretView = [[[APLSimpleCaretView alloc] initWithFrame:CGRectZero] autorelease];
    
    self.text = [NSMutableString string];
    
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)updateImageLabel
{
    self.imageLabel.text = self.text;
    [self.imageLabel resizeToSuitableHeight];
    self.contentSize = CGSizeMake(self.frame.size.width, self.imageLabel.frame.size.height);
    if(self.imageLabel.frame.size.height > self.frame.size.height){
        self.contentOffset = CGPointMake(0, self.contentSize.height - self.frame.size.height);
    }else{
        self.contentOffset = CGPointMake(0, 0);
    }
    if([self isFirstResponder]){
        if(!self.caretView.superview){
            [self addSubview:self.caretView];
        }
        [self.caretView delayBlink];
    }else{
        [self.caretView removeFromSuperview];
    }
    self.caretView.frame = [self.imageLabel caretRectAtIndex:self.caretPosition];
}

#pragma mark - events
- (void)tapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    [self becomeFirstResponder];
}


#pragma mark - UIKeyInput
- (BOOL)hasText
{
    return YES;
}

- (void)insertText:(NSString *)text
{
    if([text isEqualToString:@"i"]){
        text = [NSString stringWithFormat:@"%@image%@", YXImageLabelDefaultImageLeftMatchingText, YXImageLabelDefaultImageRightMatchingText];
    }
    [self.text appendString:text];
    self.caretPosition += text.length;
    [self updateImageLabel];
}

- (void)deleteBackward
{
    if(self.text.length != 0){
        NSRange charRange = [self.text rangeOfComposedCharacterSequenceAtIndex:self.text.length - 1];
        NSString *lastChar = [self.text substringWithRange:charRange];
        if([lastChar isEqualToString:YXImageLabelDefaultImageRightMatchingText]){
            NSRange leftRange = [self.text rangeOfString:YXImageLabelDefaultImageLeftMatchingText options:NSBackwardsSearch range:NSMakeRange(0, charRange.location)];
            if(leftRange.location != NSNotFound){
                charRange = NSMakeRange(leftRange.location, charRange.location - leftRange.location + 1);
            }
        }
        
        [self.text deleteCharactersInRange:charRange];
        self.caretPosition -= charRange.length;
        [self updateImageLabel];
    }
}

#pragma mark - UITextInput
- (NSString *)textInRange:(UITextRange *)range
{
    return nil;
}

- (void)replaceRange:(UITextRange *)range withText:(NSString *)text
{
}

- (void)setSelectedTextRange:(UITextRange *)selectedTextRange
{
}

- (UITextRange *)selectedTextRange
{
    return nil;
}

- (UITextRange *)markedTextRange
{
    return nil;
}

- (void)setMarkedTextStyle:(NSDictionary *)markedTextStyle
{
}

- (void)setMarkedText:(NSString *)markedText selectedRange:(NSRange)selectedRange
{
    self.markingText = markedText;
}

- (void)unmarkText
{
    [self insertText:self.markingText];
}

- (UITextPosition *)beginningOfDocument
{
    return nil;
}

- (UITextPosition *)endOfDocument
{
    return nil;
}

- (UITextRange *)textRangeFromPosition:(UITextPosition *)fromPosition toPosition:(UITextPosition *)toPosition
{
    return nil;
}

- (UITextPosition *)positionFromPosition:(UITextPosition *)position offset:(NSInteger)offset
{
    return nil;
}

- (UITextPosition *)positionFromPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction offset:(NSInteger)offset
{
    return nil;
}

- (NSComparisonResult)comparePosition:(UITextPosition *)position toPosition:(UITextPosition *)other
{
    return NSOrderedAscending;
}

- (NSInteger)offsetFromPosition:(UITextPosition *)from toPosition:(UITextPosition *)toPosition
{
    return 0;
}

- (UITextPosition *)positionWithinRange:(UITextRange *)range farthestInDirection:(UITextLayoutDirection)direction
{
    return nil;
}

- (UITextRange *)characterRangeByExtendingPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction
{
    return nil;
}

/* Writing direction */
- (UITextWritingDirection)baseWritingDirectionForPosition:(UITextPosition *)position inDirection:(UITextStorageDirection)direction
{
    return UITextWritingDirectionLeftToRight;
}

- (void)setBaseWritingDirection:(UITextWritingDirection)writingDirection forRange:(UITextRange *)range
{
}

/* Geometry used to provide, for example, a correction rect. */
- (CGRect)firstRectForRange:(UITextRange *)range
{
    return CGRectZero;
}

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    return CGRectZero;
}

- (NSArray *)selectionRectsForRange:(UITextRange *)range
{
    return nil;
}

- (UITextPosition *)closestPositionToPoint:(CGPoint)point
{
    return nil;
}

- (UITextPosition *)closestPositionToPoint:(CGPoint)point withinRange:(UITextRange *)range
{
    return nil;
}

- (UITextRange *)characterRangeAtPoint:(CGPoint)point
{
    return nil;
}

@end

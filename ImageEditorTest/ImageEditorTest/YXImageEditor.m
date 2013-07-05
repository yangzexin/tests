//
//  ImageEditor.m
//  ImageEditorTest
//
//  Created by yangzexin on 13-7-1.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "YXImageEditor.h"
#import "YXImageLabel.h"
#import "APLSimpleCaretView.h"

@interface YXImageEditor () <UITextInput>

@property(nonatomic, retain)NSMutableString *text;
@property(nonatomic, retain)YXImageLabel *imageLabel;

@property (nonatomic) UITextInputStringTokenizer *tokenizer;

@property(nonatomic, retain)NSString *markingText;

@property(nonatomic, assign)NSInteger caretPosition;
@property(nonatomic, retain)APLSimpleCaretView *caretView;

@end

@implementation YXImageEditor

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
    [self updateCaretView];
}

- (void)updateCaretView
{
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

- (void)setImageLeftMatchingText:(NSString *)imageLeftMatchingText
{
    self.imageLabel.imageLeftMatchingText = imageLeftMatchingText;
}

- (NSString *)imageLeftMatchingText
{
    return self.imageLabel.imageLeftMatchingText;
}

- (void)setImageRightMatchingText:(NSString *)imageRightMatchingText
{
    self.imageLabel.imageRightMatchingText = imageRightMatchingText;
}

- (NSString *)imageRightMatchingText
{
    return self.imageLabel.imageRightMatchingText;
}

- (void)setImageGetter:(UIImage *(^)(NSString *))imageGetter
{
    self.imageLabel.imageGetter = imageGetter;
}

- (UIImage *(^)(NSString *))imageGetter
{
    return self.imageLabel.imageGetter;
}

- (void)setViewGetter:(UIView *(^)(NSString *))viewGetter
{
    self.imageLabel.viewGetter = viewGetter;
}

- (UIView *(^)(NSString *))viewGetter
{
    return self.imageLabel.viewGetter;
}

#pragma mark - events
- (void)tapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    if(![self isFirstResponder]){
        [self becomeFirstResponder];
    }
    if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
        UITapGestureRecognizer *tapGestureRecognizer = (id)gestureRecognizer;
        CGPoint point = [tapGestureRecognizer locationInView:self];
        NSInteger index = [self.imageLabel caretPositionAtPoint:point];
        self.caretPosition = index;
        [self updateCaretView];
    }
}


#pragma mark - UIKeyInput
- (BOOL)hasText
{
    return YES;
}

- (void)insertText:(NSString *)text
{
    [self.text insertString:text atIndex:[self.imageLabel updatePositionForCaretPosition:self.caretPosition]];
    ++self.caretPosition;
    [self updateImageLabel];
}

- (void)deleteBackward
{
    if(self.text.length != 0 && self.caretPosition != 0){
        NSInteger numOfDeleteChars = [self.imageLabel numberOfDeleteCharsForCaretPosition:self.caretPosition];
        NSRange charRange = NSMakeRange([self.imageLabel updatePositionForCaretPosition:self.caretPosition] - numOfDeleteChars, numOfDeleteChars);
        
        [self.text deleteCharactersInRange:charRange];
        --self.caretPosition;
        [self updateImageLabel];
    }
}

#pragma mark - override methods

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

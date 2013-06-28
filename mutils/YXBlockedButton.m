//
//  YXBlockedButton.m
//  
//
//  Created by yangzexin on 13-6-28.
//
//

#import "YXBlockedButton.h"

@interface YXBlockedButton ()

@property(nonatomic, retain)UIButton *button;

@end

@implementation YXBlockedButton

@synthesize tapHandler;
@synthesize button;

- (void)dealloc
{
    self.tapHandler = nil;
    self.button = nil;
    [super dealloc];
}

- (void)initializeWithButtonType:(UIButtonType)buttonType
{
    self.button = [UIButton buttonWithType:buttonType];
    self.button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.button];
}

- (id)initWithButtonType:(UIButtonType)buttonType
{
    self = [self initWithFrame:CGRectZero];
    
    [self initializeWithButtonType:buttonType];
    
    return self;
}

- (id)init
{
    self = [self initWithFrame:CGRectZero];
    
    [self initializeWithButtonType:UIButtonTypeRoundedRect];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self initializeWithButtonType:UIButtonTypeRoundedRect];
    
    return self;
}

- (void)buttonTapped
{
    if(self.tapHandler){
        self.tapHandler();
    }
}

+ (id)buttonWithType:(UIButtonType)buttonType
{
    return [[self alloc] initWithButtonType:buttonType];
}

@end

//
//  MultipleSendController.m
//  
//
//  Created by yangzexin on 13-6-28.
//
//

#import "MultipleSendController.h"

@interface MultipleSendController ()

@property(nonatomic, retain)UITextView *textView;

@end

@implementation MultipleSendController

@synthesize textView;

- (void)dealloc
{
    self.textView = nil;
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    CGRect frame = self.view.bounds;
    frame.size.height -= 216.0f;
    self.textView = [[[UITextView alloc] initWithFrame:frame] autorelease];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textView.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:self.textView];
    
    UIBarButtonItem *sendButton = [[[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(sendButtonTapped)] autorelease];
    self.navigationItem.rightBarButtonItem = sendButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"批量发送";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)alert:(NSString *)message
{
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    [alertView show];
}

- (void)sendButtonTapped
{
    [self alert:self.textView.text];
}

@end

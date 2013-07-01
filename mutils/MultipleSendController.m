//
//  MultipleSendController.m
//  
//
//  Created by yangzexin on 13-6-28.
//
//

#import "MultipleSendController.h"
#import "IMessageCenter.h"

@interface MultipleSendController ()

@property(nonatomic, retain)UITextView *textView;

@end

@implementation MultipleSendController

@synthesize textView;

- (void)dealloc
{
    [[IMessageCenter sharedInstance] setMessageResultHandler:nil];
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
    self.textView.text = @"+8618607072328\n+8618607072318\n+8618607072338\n";
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

- (void)enumerateTextViewNumbersWithNumberHandler:(void(^)(NSString *))numberHandler
{
    if(self.textView.text.length != 0){
        NSArray *numbers = [self.textView.text componentsSeparatedByString:@"\n"];
        if(numbers.count != 0){
            for(NSString *number in numbers){
                number = [number stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if(number.length != 0){
                    if(number.length == 11){
                        number = [NSString stringWithFormat:@"+86%@", number];
                    }
                    numberHandler(number);
                }
            }
        }
    }
}

- (void)sendButtonTapped
{
    NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
    __block __typeof(self) bself = self;
    [[IMessageCenter sharedInstance] setMessageResultHandler:^(BOOL success, NSString *recipient, NSString *text){
        [bself alert:[NSString stringWithFormat:@"%@:%@, %@", recipient, text, success ? @"success" : @"fail"]];
    }];
    [self enumerateTextViewNumbersWithNumberHandler:^(NSString *number){
        [[IMessageCenter sharedInstance] sendMessageWithRecipient:number text:@"text---"];
    }];
    [self alert:[NSString stringWithFormat:@"cost:%f", [NSDate timeIntervalSinceReferenceDate] - startTime]];
}

@end

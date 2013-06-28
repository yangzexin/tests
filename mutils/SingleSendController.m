#import "SingleSendController.h"
#import "IMessageUtils.h"

@interface SingleSendController ()

@property(nonatomic, retain)UITextField *numberTextField;
@property(nonatomic, retain)UITextField *contentTextField;

@end

@implementation SingleSendController

@synthesize numberTextField;
@synthesize contentTextField;

#pragma mark - private methods
- (void)configureTextField:(UITextField *)textField
{
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textField addTarget:self action:@selector(textFieldDone) forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)alert:(NSString *)message
{
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    [alertView show];
}

#pragma mark - events
- (void)sendButtonTapped
{
    NSString *number = self.numberTextField.text;
    NSString *content = self.contentTextField.text;
    NSLog(@"%@, %@", number, content);
    NSError *error = nil;
    BOOL success = [IMessageUtils sendIMessageWithRecipient:number text:content error:&error];
    if(success){
        [self alert:@"发送成功"];
    }else{
        [self alert:[NSString stringWithFormat:@"%@", error]];
    }
}

- (void)textFieldDone
{
}

#pragma mark - overrides
- (void)dealloc
{
    self.numberTextField = nil;
    self.contentTextField = nil;
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    self.numberTextField = [[[UITextField alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 35)] autorelease];
    [self configureTextField:self.numberTextField];
    [self.view addSubview:self.numberTextField];
    
    self.contentTextField = [[[UITextField alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width - 20, 35)] autorelease];
    [self configureTextField:self.contentTextField];
    [self.view addSubview:self.contentTextField];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendButton.frame = CGRectMake(10, 90, self.view.frame.size.width - 20, 35);
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.numberTextField.text = @"+8618607072328";
    self.contentTextField.text = @"信息内容";
}

@end

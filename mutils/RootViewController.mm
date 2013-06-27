#import "RootViewController.h"
#import <xpc/xpc.h>
#import "IMessageTracker.h"

@interface RootViewController ()

@property(nonatomic, retain)UITextField *numberTextField;
@property(nonatomic, retain)UITextField *contentTextField;

@end

@implementation RootViewController

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

static BOOL sendIMessageWithRecipient(NSString *recipient, NSString *text, NSError **error)
{
    NSTimeInterval startDate = [NSDate timeIntervalSinceReferenceDate];
    
    xpc_connection_t myconnection;
    
    dispatch_queue_t queue = dispatch_queue_create("com.apple.chatkit.clientcomposeserver.xpc", DISPATCH_QUEUE_CONCURRENT);
    
    myconnection = xpc_connection_create_mach_service("com.apple.chatkit.clientcomposeserver.xpc", queue, XPC_CONNECTION_MACH_SERVICE_PRIVILEGED);
    
    xpc_connection_set_event_handler(myconnection, ^(xpc_object_t event){
        xpc_type_t xtype = xpc_get_type(event);
        if(XPC_TYPE_ERROR == xtype){
            NSLog(@"XPC sandbox connection error: %s\n", xpc_dictionary_get_string(event, XPC_ERROR_KEY_DESCRIPTION));
        }
        // Always set an event handler. More on this later.
        NSLog(@"Received an message event!");
    });
    
    xpc_connection_resume(myconnection);
    
    NSData *ser_rec = [NSPropertyListSerialization dataWithPropertyList:[NSArray arrayWithObject:recipient] format:200 options:0 error:NULL];
    
    xpc_object_t mydict = xpc_dictionary_create(0, 0, 0);
    xpc_dictionary_set_int64(mydict, "message-type", 0);
    xpc_dictionary_set_data(mydict, "recipients", [ser_rec bytes], [ser_rec length]);
    xpc_dictionary_set_string(mydict, "text", [text UTF8String]);
    
    xpc_connection_send_message(myconnection, mydict);
    xpc_connection_send_barrier(myconnection, ^{
        NSLog(@"Message has been successfully delievered");
    });
    
    BOOL success = [IMessageTracker isIMessageSentWithNumber:recipient date:startDate error:error];
    
    return success;
}

#pragma mark - events
- (void)sendButtonTapped
{
    NSString *number = self.numberTextField.text;
    NSString *content = self.contentTextField.text;
    NSLog(@"%@, %@", number, content);
    NSError *error = nil;
    BOOL success = sendIMessageWithRecipient(number, content, &error);
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

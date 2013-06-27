//
//  TestVC.m
//  testSocketConn
//
//  Created by yangzexin on 13-6-27.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import "TestVC.h"
#import "ZXSocketClient.h"

@interface TestVC ()

@property(nonatomic, retain)ZXSocketClient *socketClient;

@property(nonatomic, retain)UITextField *textField;

@end

@implementation TestVC

- (void)loadView
{
    [super loadView];
    self.textField = [[[UITextField alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 110, 35)] autorelease];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.textField];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(self.view.frame.size.width - 90, 10, 80, 35);
    [button setTitle:@"Send" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.socketClient = [[[ZXSocketClient alloc] initWithHost:@"localhost" port:1222] autorelease];
    [self.socketClient connect];
    [self.socketClient setAvailableBytesHandler:^{
        NSLog(@"callback:%@", [self.socketClient readUTF8String]);
    }];
    NSLog(@"connected..");
}

#pragma mark - events
- (void)buttonTapped
{
    if(self.textField.text.length != 0){
        [self.socketClient writeWithUTF8String:self.textField.text];
        self.textField.text = @"";
    }
}

@end

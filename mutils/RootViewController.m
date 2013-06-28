//
//  RootViewController.m
//  
//
//  Created by yangzexin on 13-6-28.
//
//

#import "RootViewController.h"
#import "YXBlockedButton.h"
#import "SingleSendController.h"

@implementation RootViewController

- (void)loadView
{
    [super loadView];
    
    YXBlockedButton *button = [YXBlockedButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, 10, 80, 80);
    [button.button setTitle:@"单个号码" forState:UIControlStateNormal];
    __block __typeof(self) bself = self;
    [button setTapHandler:^{
        SingleSendController *singleSendController = [[SingleSendController new] autorelease];
        [bself.navigationController pushViewController:singleSendController animated:YES];
    }];
    [self.view addSubview:button];
}

@end

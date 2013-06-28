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
#import "MultipleSendController.h"
#import "ServerSendController.h"

@implementation RootViewController

- (void)addNewButtonWithTitle:(NSString *)title frame:(CGRect)frame tapHandler:(void(^)())tapHandler
{
    YXBlockedButton *button = [YXBlockedButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = frame;
    [button.button setTitle:title forState:UIControlStateNormal];
    [button setTapHandler:tapHandler];
    [self.view addSubview:button];
}

- (void)loadView
{
    [super loadView];
    
    __block __typeof(self) bself = self;
    
    [self addNewButtonWithTitle:@"单个号码" frame:CGRectMake(10, 10, 90, 80) tapHandler:^{
        SingleSendController *singleSendController = [[SingleSendController new] autorelease];
        [bself.navigationController pushViewController:singleSendController animated:YES];
    }];
    
    [self addNewButtonWithTitle:@"批量发送" frame:CGRectMake(110, 10, 90, 80) tapHandler:^{
        MultipleSendController *multiple = [[MultipleSendController new] autorelease];
        [bself.navigationController pushViewController:multiple animated:YES];
    }];
    
    [self addNewButtonWithTitle:@"连接服务器" frame:CGRectMake(210, 10, 100, 80) tapHandler:^{
        ServerSendController *server = [[ServerSendController new] autorelease];
        [bself.navigationController pushViewController:server animated:YES];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end

//
//  RedPacketViewController.m
//  SealTalk
//
//  Created by ChrisLaw on 2017/11/27.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "RedPacketViewController.h"
#import "RCDUIBarButtonItem.h"
#import <WebKit/WebKit.h>
#import "UIColor+RCColor.h"
@interface RedPacketViewController ()

@end

@implementation RedPacketViewController
UIWebView *rpView;
- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rectOfStatusbar = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectOFNavigationbar = self.navigationController.navigationBar.frame;
    rpView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                                self.view.frame.size.height-rectOFNavigationbar.size.height-rectOfStatusbar.size.height)];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:201.0f/255.0f green:97.0f/255.0f blue:72.0f/255.0f alpha:1];
   [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSURL *url = [NSURL URLWithString:_path];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    [rpView loadRequest:request];
    [self.view addSubview:rpView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"0195ff" alpha:1.0f];
    [self.navigationController.navigationBar setShadowImage:nil];
}


@end

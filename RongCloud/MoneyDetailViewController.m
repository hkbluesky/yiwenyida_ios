//
//  MoneyDetailViewController.m
//  SealTalk
//
//  Created by ChrisLaw on 2017/11/28.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "MoneyDetailViewController.h"
#import "RCDUIBarButtonItem.h"
#import <WebKit/WebKit.h>
@interface MoneyDetailViewController ()

@end

@implementation MoneyDetailViewController
WKWebView *mdView;
- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rectOfStatusbar = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectOFNavigationbar = self.navigationController.navigationBar.frame;
    mdView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                                         self.view.frame.size.height-rectOFNavigationbar.size.height-rectOfStatusbar.size.height)];
    
}
- (void)viewWillAppear:(BOOL)animated{
    NSURL *url = [NSURL URLWithString:_path];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    [mdView loadRequest:request];
    [self.view addSubview:mdView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

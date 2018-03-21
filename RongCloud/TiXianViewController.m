//
//  TiXianViewController.m
//  SealTalk
//
//  Created by ChrisLaw on 2017/11/29.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "TiXianViewController.h"

@interface TiXianViewController ()

@end

@implementation TiXianViewController
UIWebView *webView;
- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rectOfStatusbar = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectOFNavigationbar = self.navigationController.navigationBar.frame;
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                                         self.view.frame.size.height-rectOFNavigationbar.size.height-rectOfStatusbar.size.height)];
}
- (void)viewWillAppear:(BOOL)animated{
    [webView loadRequest:_request];
    [self.view addSubview:webView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

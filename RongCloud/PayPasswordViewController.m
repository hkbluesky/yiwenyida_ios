//
//  PayPasswordViewController.m
//  SealTalk
//
//  Created by ChrisLaw on 2017/11/29.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "PayPasswordViewController.h"
#import "RCDSettingsTableViewController.h"
#import "AFHttpTool.h"
#import "RCDRCIMDataSource.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RCDUIBarButtonItem.h"
#import "UIColor+RCColor.h"
@interface PayPasswordViewController () <UIWebViewDelegate>
@property(nonatomic, strong) RCDUIBarButtonItem *rightBtn;
@end

@implementation PayPasswordViewController
UIWebView *webView;
- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rectOFNavigationbar = self.navigationController.navigationBar.frame;
    CGRect rectOfStatusbar = [[UIApplication sharedApplication] statusBarFrame];
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                                         self.view.frame.size.height-rectOFNavigationbar.size.height-rectOfStatusbar.size.height)];
    [webView setDelegate:self];
    self.rightBtn =
    [[RCDUIBarButtonItem alloc] initWithbuttonTitle:NSLocalizedStringFromTable(@"Done", @"RongCloudKit",nil)
                                         titleColor:[UIColor colorWithHexString:@"9fcdfd" alpha:1.0]
                                        buttonFrame:CGRectMake(0, 0, 50, 30)
                                             target:self
                                             action:@selector(saveNewPassword:)];
    [self.rightBtn buttonIsCanClick:NO
                        buttonColor:[UIColor colorWithHexString:@"9fcdfd" alpha:1.0]
                      barButtonItem:self.rightBtn];
    self.navigationItem.rightBarButtonItems = [self.rightBtn
                                               setTranslation:self.rightBtn
                                               translation:-11];
}
- (void)saveNewPassword:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [AFHttpTool getTokenSuccess:^(id response) {
        NSString *token = response[@"result"][@"token"];
        NSString *userid = [RCIM sharedRCIM].currentUserInfo.userId;
        NSString *urlString = [NSString stringWithFormat:@"http://wx.garase.net/user/acount/change_pay_passwd/%@?token=%@",userid,token];
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [webView loadRequest:request];
        [self.view addSubview:webView];
    }failure:^(NSError *err) {
        
    }];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"passValue"] = ^{
        NSArray *arg = [JSContext currentArguments];
        NSString *tmp = nil;
        tmp = [arg[0] toString];
        if([tmp isEqualToString:@"password"]){
            [self.rightBtn buttonIsCanClick:YES
                                buttonColor:[UIColor whiteColor]
                              barButtonItem:self.rightBtn];
        }
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

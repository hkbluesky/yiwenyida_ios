//
//  AlipayViewController.m
//  SealTalk
//
//  Created by ChrisLaw on 2018/3/1.
//  Copyright © 2018年 RongCloud. All rights reserved.
//

#import "AlipayViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <AlipaySDK/AlipaySDK.h>
#import <RongIMKit/RongIMKit.h>
#import "WXApi.h"
#import "WechatAuthSDK.h"
#import "WXApiObject.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface AlipayViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *netView;
@end

@implementation AlipayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rectOfStatusbar = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectOFNavigationbar = self.navigationController.navigationBar.frame;
    self.netView= [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                                         self.view.frame.size.height-rectOFNavigationbar.size.height-rectOfStatusbar.size.height)];
    [self.netView setDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPage) name:@"refreshMoneyPage" object:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    NSString *str1 = [NSString stringWithFormat:@"https://ask.vipjingjie.com/moblie/wallet?userid=%@",[RCIM sharedRCIM].currentUserInfo.userId];
    NSString *str2 = [NSString stringWithFormat:@"&locate=%@",[self getPreferredLanguage]];
    NSString *path = [str1 stringByAppendingString:str2];
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.netView loadRequest:request];
    [self.view addSubview:self.netView];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"passValue"] = ^{
        //NSString *switchBtn = nil;
        NSString *type = nil;
        NSString *partnerId = nil;
        NSString *prepayId = nil;
        NSString *nonceStr = nil;
        NSString *timeStamp = nil;
        NSString *package = nil;
        NSString *sign = nil;
        NSString *str = nil;
        NSArray *arg = [JSContext currentArguments];
        type = [arg[0] toString];

        if([type isEqualToString:@"1"]){
            str= [arg[1] toString];
            AlipaySDK *aliService = [AlipaySDK defaultService];
            [aliService payOrder:str fromScheme:@"yiwenyida" callback:^(NSDictionary *resultDic) {

            }];
        }else if([type isEqualToString:@"2"]){
        
            partnerId = [arg[1] toString];
            prepayId = [arg[2] toString];
            nonceStr = [arg[3] toString];
            timeStamp = [arg[4] toString];
            package = [arg[5] toString];
            sign = [arg[6] toString];
            PayReq* req= [[PayReq alloc] init];
            req.partnerId = partnerId;
            req.prepayId = prepayId;
            req.nonceStr = nonceStr;
            req.timeStamp = timeStamp.intValue;
            req.package = package;
            req.sign = sign;
            [WXApi sendReq:req];
        }
      
        
    };
}

-(void)refreshPage{
    NSString *path = [NSString stringWithFormat:@"https://ask.vipjingjie.com/moblie/wallet?userid=%@",[RCIM sharedRCIM].currentUserInfo.userId];
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.netView loadRequest:request];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString*)getPreferredLanguage{
    
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    
    NSString* preferredLang = [languages objectAtIndex:0];
    
    if([preferredLang containsString:@"zh"]){
        return @"zh";
    }else{
        return @"en";
    }
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

//
//  MyMoneyViewController.m
//  SealTalk
//
//  Created by ChrisLaw on 2017/11/25.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMoneyViewController.h"
#import "RCDRCIMDataSource.h"
#import "RCDUIBarButtonItem.h"
#import "WXApi.h"
#import "WechatAuthSDK.h"
#import "WXApiObject.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "AFHttpTool.h"
#import "AFNetworking.h"
#import "MoneyDetailViewController.h"
#import "TiXianViewController.h"
#define WXDoctor_App_ID @"wx9a0257bda59d2a00"  // 注册微信时的AppID
#define WXDoctor_App_Secret @"d160a8bf603019b8ecd0e2685940cf3d" // 注册时得到的AppSecret
#define WXPatient_App_ID @"wx9a0257bda59d2a00"
#define WXPatient_App_Secret @"d160a8bf603019b8ecd0e2685940cf3d"
#define WX_ACCESS_TOKEN @"access_token"
#define WX_OPEN_ID @"openid"
#define WX_REFRESH_TOKEN @"refresh_token"
#define WX_UNION_ID @"unionid"
#define WX_BASE_URL @"https://api.weixin.qq.com/sns"
@interface MyMoneyViewController ()
@property (copy, nonatomic) void (^requestForUserInfoBlock)();
@end

@implementation MyMoneyViewController
UIWebView *webView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的零钱";
    // Do any additional setup after loading the view.
    CGRect rectOfStatusbar = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectOFNavigationbar = self.navigationController.navigationBar.frame;
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                                                    self.view.frame.size.height-rectOFNavigationbar.size.height-rectOfStatusbar.size.height)];
    [self.view addSubview:webView];
    [webView setDelegate:self];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"passValue"] = ^{
        NSString *switchBtn = nil;
        NSString *partnerId = nil;
        NSString *prepayId = nil;
        NSString *nonceStr = nil;
        NSString *timeStamp = nil;
        NSString *package = nil;
        NSString *sign = nil;
        NSArray *arg = [JSContext currentArguments];
        switchBtn = [arg[0] toString];
        if([switchBtn isEqualToString:@"tixian"]){
            //提现
            [self wechatLoginClick:(nil)];
        
            
        }else{
            //充值
            partnerId = [arg[0] toString];
            prepayId = [arg[1] toString];
            nonceStr = [arg[2] toString];
            timeStamp = [arg[3] toString];
            package = [arg[4] toString];
            sign = [arg[5] toString];
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
- (void)setupAlertController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *rightButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"零钱明细" style:UIBarButtonItemStylePlain target:self action:@selector(detail:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [AFHttpTool getTokenSuccess:^(id response) {
        NSString *token = response[@"result"][@"token"];
        NSString *userid = [RCIM sharedRCIM].currentUserInfo.userId;
        NSString *urlString = [NSString stringWithFormat:@"http://test.garase.net/user/acount/index/%@?token=%@",userid,token];
        urlString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlString, NULL, CFSTR("#%<>[\\]^`{|}\"]+"), kCFStringEncodingUTF8));
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [webView loadRequest:request];
    }failure:^(NSError *err) {
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)detail:(id)sender {
    [AFHttpTool getTokenSuccess:^(id response) {
        NSString *token = response[@"result"][@"token"];
        NSString *userid = [RCIM sharedRCIM].currentUserInfo.userId;
        NSString *urlString = [NSString stringWithFormat:@"http://test.garase.net/user/acount/deal/%@?token=%@",userid,token];
        MoneyDetailViewController *mdVC = [[MoneyDetailViewController alloc]init];
        mdVC.path = urlString;
        [self showViewController:mdVC sender:@"mdVC"];
        NSURL *url = [NSURL URLWithString:urlString];
    }failure:^(NSError *err) {
        
    }];
    
}
- (IBAction)wechatLoginClick:(id)sender {
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_ACCESS_TOKEN];
    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID];
    NSString *unionID = [[NSUserDefaults standardUserDefaults] objectForKey:WX_UNION_ID];
    // 如果已经请求过微信授权登录，那么考虑用已经得到的access_token
    if (accessToken && openID) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_REFRESH_TOKEN];
        NSString *refreshUrlStr = [NSString stringWithFormat:@"%@/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@", WX_BASE_URL, WXPatient_App_ID, refreshToken];
        [manager GET:refreshUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"请求reAccess的response = %@", responseObject);
            NSDictionary *refreshDict = [NSDictionary dictionaryWithDictionary:responseObject];
            NSString *reAccessToken = [refreshDict objectForKey:WX_ACCESS_TOKEN];
            // 如果reAccessToken为空,说明reAccessToken也过期了,反之则没有过期
            if (reAccessToken) {
                // 更新access_token、refresh_token、open_id
                [[NSUserDefaults standardUserDefaults] setObject:reAccessToken forKey:WX_ACCESS_TOKEN];
                [[NSUserDefaults standardUserDefaults] setObject:[refreshDict objectForKey:WX_OPEN_ID] forKey:WX_OPEN_ID];
                [[NSUserDefaults standardUserDefaults] setObject:[refreshDict objectForKey:WX_REFRESH_TOKEN] forKey:WX_REFRESH_TOKEN];
                [[NSUserDefaults standardUserDefaults] synchronize];
                // 当存在reAccessToken不为空时直接执行AppDelegate中的wechatLoginByRequestForUserInfo方法
                !self.requestForUserInfoBlock ? : self.requestForUserInfoBlock();
            }
            else {
                [self wechatLogin];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"用refresh_token来更新accessToken时出错 = %@", error);
        }];
        //跳转去取钱
        [AFHttpTool getTokenSuccess:^(id response) {
            NSString *token = response[@"result"][@"token"];
            NSString *userid = [RCIM sharedRCIM].currentUserInfo.userId;
            NSString *urlString = [NSString stringWithFormat:@"http://test.garase.net/user/acount/withdrawal_tx/%@?openid=%@&unionid=%@&token=%@",userid,openID,unionID,token];
            NSURL *url = [NSURL URLWithString:urlString];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            TiXianViewController *txVC = [[TiXianViewController alloc]init];
            txVC.request = request;
            [self showViewController:txVC sender:@"txVC"];
            
        }failure:^(NSError *err) {
            
        }];
        
    }else {
        [self wechatLogin];
    }
}
- (void)wechatLogin {
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"Taoxinzi";
        [WXApi sendReq:req];
    }
    else {
        [self setupAlertController];
    }
}


@end

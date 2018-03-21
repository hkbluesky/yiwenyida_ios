//
//  QuanViewController.m
//  RCloudMessage
//
//  Created by ChrisLaw on 2017/9/18.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "QuanViewController.h"
#import "RCDUIBarButtonItem.h"
#import "RCDUserInfo.h"
#import "RCDRCIMDataSource.h"
#import "AFHttpTool.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDChatViewController.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/albbsdk.h>
#import <AlibcTradeBiz/AlibcTradeBiz.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "WXApi.h"
#import "WechatAuthSDK.h"
#import "WXApiObject.h"
@interface QuanViewController () <UIWebViewDelegate>
@property(nonatomic, assign) BOOL isClick;
@property(nonatomic, strong) loginSuccessCallback loginSuccessCallback;
@property(nonatomic, strong) loginFailureCallback loginFailedCallback;
@end

@implementation QuanViewController
UIWebView *webView = nil;
NSString *title = nil;
NSString *pid = nil;
NSString *pUrl = nil;
id<AlibcTradePage> page;
id<AlibcTradeService> service;
AlibcTradeTaokeParams *taoKeParams;
AlibcTradeShowParams* showParam;
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = request.URL;
    if ([url.absoluteString hasPrefix:@"tbopen://"]||[url.absoluteString hasPrefix:@"taobao://"]) {
        return NO;
    }
//    if (navigationType == UIWebViewNavigationTypeLinkClicked)
//    {
//        if(![[ALBBSession sharedInstance] isLogin]){
//            [[ALBBSDK sharedInstance] auth:self successCallback:_loginSuccessCallback failureCallback:_loginFailedCallback];
//        }else{
//
//
//        }
//    }
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"passValue"] = ^{
        NSString *toWhere = @"";
        NSString *title = @"";
        NSString *icon = @"";
        NSArray *arg = [JSContext currentArguments];
        for(int i=0;i<arg.count;i++){
            switch (i) {
                case 0:
                    toWhere = [arg[i] toString];
                    break;
                case 1:
                    title = [arg[i] toString];
                    break;
                case 2:
                    icon = [arg[i] toString];
                    break;
                default:
                    break;
            }
        }

        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = title;
        WXMediaMessage *message = [WXMediaMessage message];
        NSURL *url = [NSURL URLWithString:icon];
        [self compressedImageFiles:[UIImage imageWithData:[NSData dataWithContentsOfURL:url]] imageKB:30 imageBlock:^(UIImage *image) {
            [message setThumbImage:image];
        }];
        //[message setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:url]]];
        WXImageObject *imageObject = [WXImageObject object];
        //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res1" ofType:@"jpg"];
        imageObject.imageData = [NSData dataWithContentsOfURL:url];
        message.mediaObject = imageObject;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        //req.text = title;
        req.bText = NO;
        req.message = message;
        if(toWhere.integerValue==0){
            req.scene = WXSceneTimeline;
        }else{
            req.scene = WXSceneSession;
        }
        //[WXApi sendReq:req];
        BOOL isSuccess = [WXApi sendReq:req];
        if(isSuccess){
            NSLog(@"成功");
        }
    };
}
- (void)compressedImageFiles:(UIImage *)image
                     imageKB:(CGFloat)fImageKBytes
                  imageBlock:(void(^)(UIImage *image))block {
    
    __block UIImage *imageCope = image;
    CGFloat fImageBytes = fImageKBytes * 1024;//需要压缩的字节Byte
    
    __block NSData *uploadImageData = nil;
    
    uploadImageData = UIImagePNGRepresentation(imageCope);
    NSLog(@"图片压前缩成 %fKB",uploadImageData.length/1024.0);
    CGSize size = imageCope.size;
    CGFloat imageWidth = size.width;
    CGFloat imageHeight = size.height;
    
    if (uploadImageData.length > fImageBytes && fImageBytes >0) {
        
        dispatch_async(dispatch_queue_create("CompressedImage", DISPATCH_QUEUE_SERIAL), ^{
            
            /* 宽高的比例 **/
            CGFloat ratioOfWH = imageWidth/imageHeight;
            /* 压缩率 **/
            CGFloat compressionRatio = fImageBytes/uploadImageData.length;
            /* 宽度或者高度的压缩率 **/
            CGFloat widthOrHeightCompressionRatio = sqrt(compressionRatio);
            
            CGFloat dWidth   = imageWidth *widthOrHeightCompressionRatio;
            CGFloat dHeight  = imageHeight*widthOrHeightCompressionRatio;
            if (ratioOfWH >0) { /* 宽 > 高,说明宽度的压缩相对来说更大些 **/
                dHeight = dWidth/ratioOfWH;
            }else {
                dWidth  = dHeight*ratioOfWH;
            }
            
            imageCope = [self drawWithWithImage:imageCope width:dWidth height:dHeight];
            uploadImageData = UIImagePNGRepresentation(imageCope);
            
            NSLog(@"当前的图片已经压缩成 %fKB",uploadImageData.length/1024.0);
            //微调
            NSInteger compressCount = 0;
            /* 控制在 1M 以内**/
            while (fabs(uploadImageData.length - fImageBytes) > 1024) {
                /* 再次压缩的比例**/
                CGFloat nextCompressionRatio = 0.9;
                
                if (uploadImageData.length > fImageBytes) {
                    dWidth = dWidth*nextCompressionRatio;
                    dHeight= dHeight*nextCompressionRatio;
                }else {
                    dWidth = dWidth/nextCompressionRatio;
                    dHeight= dHeight/nextCompressionRatio;
                }
                
                imageCope = [self drawWithWithImage:imageCope width:dWidth height:dHeight];
                uploadImageData = UIImagePNGRepresentation(imageCope);
                
                /*防止进入死循环**/
                compressCount ++;
                if (compressCount == 10) {
                    break;
                }
                
            }
            
            NSLog(@"图片已经压缩成 %fKB",uploadImageData.length/1024.0);
            imageCope = [[UIImage alloc] initWithData:uploadImageData];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                block(imageCope);
            });
        });
    }
    else
    {
        block(imageCope);
    }
}
- (UIImage *)drawWithWithImage:(UIImage *)imageCope width:(CGFloat)dWidth height:(CGFloat)dHeight{
    
    UIGraphicsBeginImageContext(CGSizeMake(dWidth, dHeight));
    [imageCope drawInRect:CGRectMake(0, 0, dWidth, dHeight)];
    imageCope = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCope;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.navigationController.navigationBar.tintColor =
    [UIColor whiteColor];
    CGRect rectOfStatusbar = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectOFNavigationbar = self.navigationController.navigationBar.frame;
    webView= [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                                         self.view.frame.size.height-rectOFNavigationbar.size.height*2-rectOfStatusbar.size.height)];
    [webView setDelegate:self];
//    _loginSuccessCallback=^(ALBBSession *session){
//        NSString *tip=[NSString stringWithFormat:@"登录的用户信息:%@",[session getUser]];
//        NSLog(@"%@", tip);
//        [[MyAlertView alertViewWithTitle:@"登录成功" message:tip oALinClicked:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
//    };
//
//    _loginFailedCallback=^(ALBBSession *session, NSError *error){
//        NSString *tip=[NSString stringWithFormat:@"登录失败:%@",@""];
//        NSLog(@"%@", tip);
//        [[MyAlertView alertViewWithTitle:@"登录失败" message:tip oALinClicked:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
//    };
    
}




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isClick = YES;
    RCDUIBarButtonItem *rightBtn =
    [[RCDUIBarButtonItem alloc] initContainImage:[UIImage imageNamed:@"home"]
                                  imageViewFrame:CGRectMake(0, 6, 24, 24)
                                     buttonTitle:nil
                                      titleColor:nil
                                      titleFrame:CGRectZero
                                     buttonFrame:CGRectMake(0, 6, 24, 24)
                                          target:self
                                          action:@selector(gohome:)];
    self.tabBarController.navigationItem.rightBarButtonItems = [rightBtn setTranslation:rightBtn translation:0];
    RCDUIBarButtonItem *leftbtn =
    [[RCDUIBarButtonItem alloc] initContainImage:[UIImage imageNamed:@"left_arrow"]
                                  imageViewFrame:CGRectMake(0, 6, 24, 24)
                                     buttonTitle:nil
                                      titleColor:nil
                                      titleFrame:CGRectZero
                                     buttonFrame:CGRectMake(0, 6, 24, 24)
                                          target:self
                                          action:@selector(goback:)];
    self.tabBarController.navigationItem.leftBarButtonItems = [leftbtn setTranslation:leftbtn translation:0];
    
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    NSString *userid = [RCIM sharedRCIM].currentUserInfo.userId;
    
    [AFHttpTool getUserInfo:userid
                    success:^(id response) {
                        if ([response[@"code"] intValue] == 200) {
                            NSDictionary *result = response[@"result"];
                            pid  = result[@"pid"];
                            pUrl = result[@"url"];
                            title = result[@"title"];
                            if(title==nil||[title isEqualToString:@""]){
                                self.tabBarController.navigationItem.title = @"优惠券";
                            }else{
                               self.tabBarController.navigationItem.title = title;
                            }
                            if(pUrl==nil||[pUrl isEqualToString:@""]){
                                page = [AlibcTradePageFactory page: [NSString stringWithFormat:@"http://qianyan.huiwanjingjie.com/app/index.php?i=8&c=entry&do=index2&m=xuangou&mid=%@",pid]];
                                NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://qianyan.huiwanjingjie.com/app/index.php?i=8&c=entry&do=index2&m=xuangou&mid=%@",pid]]];
                                [self webView:webView shouldStartLoadWithRequest:request navigationType:UIWebViewNavigationTypeLinkClicked];
                                //id<AlibcTradePage> page = [AlibcTradePageFactory itemDetailPage:@"40856908517"];
                                service= [AlibcTradeSDK sharedInstance].tradeService;
                                //淘客信息
                                taoKeParams=[[AlibcTradeTaokeParams alloc] init];
                                taoKeParams.pid=pid;
                                [[AlibcTradeSDK sharedInstance] setTaokeParams:taoKeParams];
                                //打开方式
                                showParam = [[AlibcTradeShowParams alloc] init];
                                showParam.openType = AlibcOpenTypeH5;
                                showParam.isNeedPush=NO;
                                [[AlibcTradeSDK sharedInstance].tradeService
                                 show:self
                                 webView:webView
                                 page:page
                                 showParams:showParam
                                 taoKeParams: taoKeParams
                                 trackParam:nil
                                 tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result){
                                     NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://qianyan.huiwanjingjie.com/app/index.php?i=8&c=entry&do=index2&m=xuangou&mid=%@",pid]]];
                                     [webView loadRequest:(request)];
                                 }
                                 tradeProcessFailedCallback:^(NSError * _Nullable error){
                                     
                                 }];
                            }else{
                                //进入代理页面
                                NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?mid=%@",pUrl,pid]]];
                                [webView loadRequest:request];
                            }
                            
                        }
                        
                    }
                    failure:^(NSError *err){
                        self.tabBarController.navigationItem.title = @"优惠券";
                    }];
    
    
    [self.view addSubview:webView];
//    if(![[ALBBSession sharedInstance] isLogin]){
//        [[ALBBSDK sharedInstance] auth:self successCallback:_loginSuccessCallback failureCallback:_loginFailedCallback];
//    }else{
//
//    }
    
}
- (void)viewDidDisappear:(BOOL)animated{
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)goback:(id)sender {
    if(webView.canGoBack){
        webView.goBack;
    }
}
- (void)gohome:(id)sender {
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://qianyan.huiwanjingjie.com/app/index.php?i=8&c=entry&do=index2&m=xuangou&mid=%@",pid]]];
    [webView loadRequest:(request)];
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


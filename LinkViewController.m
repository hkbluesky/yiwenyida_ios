//
//  LinkViewController.m
//  SealTalk
//
//  Created by ChrisLaw on 2017/10/19.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "LinkViewController.h"
#import "RCDUIBarButtonItem.h"
#import "RCDUserInfo.h"
#import "RCDRCIMDataSource.h"
#import "AFHttpTool.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDChatViewController.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "WXApi.h"
#import "WechatAuthSDK.h"
#import "WXApiObject.h"
@interface LinkViewController () <UIWebViewDelegate>
@property(nonatomic, assign) BOOL isClick;
@end

@implementation LinkViewController
UIWebView *netView = nil;
NSString *mid = nil;
id<AlibcTradePage> page;
id<AlibcTradeService> service;
AlibcTradeTaokeParams *taoKeParams;
AlibcTradeShowParams* showParam;
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
    netView= [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                                         self.view.frame.size.height-rectOFNavigationbar.size.height-rectOfStatusbar.size.height)];
    //[self.view addSubview:netView];
    [netView setDelegate:self];
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
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = request.URL;
    if ([url.absoluteString hasPrefix:@"tbopen://"]) {
        return NO;
    }
    return YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isClick = YES;

    NSString *userid = [RCIM sharedRCIM].currentUserInfo.userId;
    if(_path!=nil){
        [AFHttpTool getUserInfo:userid
                        success:^(id response) {
                            if ([response[@"code"] intValue] == 200) {
                                NSDictionary *result = response[@"result"];
                                mid  = result[@"pid"];
                                
                                service= [AlibcTradeSDK sharedInstance].tradeService;
                                //淘客信息
                                taoKeParams=[[AlibcTradeTaokeParams alloc] init];
                                taoKeParams.pid=mid;
                                [[AlibcTradeSDK sharedInstance] setTaokeParams:taoKeParams];
                                //打开方式
                                showParam = [[AlibcTradeShowParams alloc] init];
                                showParam.openType = AlibcOpenTypeH5;
                                if ([_path containsString:@"&"]) {
                                    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&mid=%@",_path,mid]]];
                                    // 3.加载网页ß
                                    [self webView:netView shouldStartLoadWithRequest:request navigationType:UIWebViewNavigationTypeLinkClicked];
                                    page = [AlibcTradePageFactory page: [NSString stringWithFormat:@"%@&mid=%@",_path,mid]];
                                    [[AlibcTradeSDK sharedInstance].tradeService
                                     show:self
                                     webView:netView
                                     page:page
                                     showParams:showParam
                                     taoKeParams: taoKeParams
                                     trackParam:nil
                                     tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result){
                                         NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&mid=%@",_path,mid]]];
                                         [netView loadRequest:(request)];
                                     }
                                     tradeProcessFailedCallback:^(NSError * _Nullable error){
                                         
                                     }];
                                    
                                    // 最后将webView添加到界面
                                    [self.view addSubview:netView];
                                } else {
                                    if([_path containsString:@"?"]){
                                        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&mid=%@",_path,mid]]];
                                        // 3.加载网页ß
                                        [self webView:netView shouldStartLoadWithRequest:request navigationType:UIWebViewNavigationTypeLinkClicked];
                                        page = [AlibcTradePageFactory page: [NSString stringWithFormat:@"%@&mid=%@",_path,mid]];
                                        [[AlibcTradeSDK sharedInstance].tradeService
                                         show:self
                                         webView:netView
                                         page:page
                                         showParams:showParam
                                         taoKeParams: taoKeParams
                                         trackParam:nil
                                         tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result){
                                             NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&mid=%@",_path,mid]]];
                                             [netView loadRequest:(request)];
                                         }
                                         tradeProcessFailedCallback:^(NSError * _Nullable error){
                                             
                                         }];
                                        [self.view addSubview:netView];
                                    }else{
                                        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?mid=%@",_path,mid]]];
                                        // 3.加载网页ß
                                        [self webView:netView shouldStartLoadWithRequest:request navigationType:UIWebViewNavigationTypeLinkClicked];
                                        page = [AlibcTradePageFactory page: [NSString stringWithFormat:@"%@?mid=%@",_path,mid]];
                                        [[AlibcTradeSDK sharedInstance].tradeService
                                         show:self
                                         webView:netView
                                         page:page
                                         showParams:showParam
                                         taoKeParams: taoKeParams
                                         trackParam:nil
                                         tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result){
                                             NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?mid=%@",_path,mid]]];
                                             [netView loadRequest:(request)];
                                         }
                                         tradeProcessFailedCallback:^(NSError * _Nullable error){
                                             
                                         }];
                                        [self.view addSubview:netView];
                                        
                                    }
                                    
                                    
                                    // 最后将webView添加到界面
                                    
                                }
                                
                                
                                
                            }
                        }
                        failure:^(NSError *err){
                            
                        }];
            }
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

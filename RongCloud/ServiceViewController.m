//
//  ServiceViewController.m
//  SealTalk
//
//  Created by ChrisLaw on 2018/1/24.
//  Copyright © 2018年 RongCloud. All rights reserved.
//

#import "ServiceViewController.h"
#import "VideoEndView.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDRCIMDataSource.h"
#import "RCDHttpTool.h"
#import "RCDUserInfoManager.h"
#import "RCDChatViewController.h"
#import "AFHttpTool.h"
#import "RCDUIBarButtonItem.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <RongCallKit/RongCallKit.h>
@interface ServiceViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSTimer *timer2;
@property (nonatomic,strong) NSTimer *timer3;
@property (nonatomic,strong) NSTimer *stopTimer;
@property (nonatomic,copy) NSString *videoPrice;
@property (nonatomic,assign) int i;
@property (nonatomic,assign) BOOL ifsend;
@property (nonatomic,assign) int y;
@property (nonatomic,copy) NSString *targetId;
@end

@implementation ServiceViewController{
    dispatch_source_t dtimer;
    dispatch_source_t dtimer2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenNavigation) name:@"removeVideoEndView" object:nil];
    self.webView= [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                                         self.view.frame.size.height-40*2-20)];
    [self.webView setDelegate:self];
    [self.view addSubview:self.webView];
//    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction)];
//    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:swipeRight];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if([self.webView canGoBack]){
        
    }else{
        NSString *str1 = [NSString stringWithFormat:@"https://ask.vipjingjie.com/moblie/app/index?userid=%@",[RCIM sharedRCIM].currentUserInfo.userId];
        NSString *str2 = [NSString stringWithFormat:@"&locate=%@",[self getPreferredLanguage]];
        NSString *urlStr = [str1 stringByAppendingString:str2];
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        
        NSString * path = [cachesPath stringByAppendingString:[NSString stringWithFormat:@"/Caches/%lu.html",(unsigned long)[urlStr hash]]];
        
        NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        
        
        if (!(htmlString ==nil || [htmlString isEqualToString:@""])) {
            
            //[self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:urlStr]];
            NSURL *url = [NSURL URLWithString:path];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [self.webView loadRequest:request];
        }else{
            
            NSURL *url = [NSURL URLWithString:urlStr];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            [self.webView loadRequest:request];
            
            [self writeToCache:urlStr];
            
        }
    }
    [self performSelector:@selector(updateTitle) withObject:nil];
    
}
-(void)updateTitle{
    NSString *urlStr = [NSString stringWithFormat:@"https://ask.vipjingjie.com/moblie/personalAike?userid=%@",[RCIM sharedRCIM].currentUserInfo.userId];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __weak typeof(&*self) weakSelf = self;
        NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSString *result = [accessDict objectForKey:@"result"];
        if([result isEqualToString:@"1"]){
            NSString *aike = [accessDict objectForKey:@"aike"];
            [weakSelf performSelectorOnMainThread:@selector(updateText:) withObject:aike waitUntilDone:NO];
        }
    }];
    [dataTask resume];
}
-(void)updateText:(NSString *)aike{
    NSString *title = NSLocalizedStringFromTable(@"ServiceViewTabBarTitle", @"RongCloudKit",
                                                 nil);
    NSString *remain = NSLocalizedStringFromTable(@"remain", @"RongCloudKit",
                                                  nil);
    NSString *str = [NSString stringWithFormat:@"%@(%@:%@)",title,remain,aike];
    self.tabBarController.navigationItem.title = str;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startVideoCall{
    [[RCCall sharedRCCall] startSingleCall:self.targetId
                                 mediaType:RCCallMediaVideo];
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(checkCallState) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    self.i=0;
}
-(void)startVoiceCall{
    [[RCCall sharedRCCall] startSingleCall:self.targetId
                                 mediaType:RCCallMediaAudio];
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(checkCallState) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    self.i=0;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"passValue"] = ^{
        NSArray *arg = [JSContext currentArguments];
        NSString *userid = [arg[0] toString];
        self.targetId = userid;
        NSString * type = [arg[1] toString];
        if([type isEqualToString:@"video"]){
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://ask.vipjingjie.com/moblie/checkIfEnoughMoney?type=video&userid=%@&targetid=%@",[RCIM sharedRCIM].currentUserInfo.userId,self.targetId]];
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                __weak typeof(&*self) weakSelf = self;
                //解析JSON
                NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                NSString *result = [accessDict objectForKey:@"result"];
                if([result isEqualToString:@"1"]){
                    [weakSelf performSelectorOnMainThread:@selector(startVideoCall) withObject:nil waitUntilDone:NO];
                }else if([result isEqualToString:@"0"]){
                    [weakSelf performSelectorOnMainThread:@selector(alertSomething2) withObject:nil waitUntilDone:NO];
                }else if([result isEqualToString:@"2"]){
                    [weakSelf performSelectorOnMainThread:@selector(alertSomething3:) withObject:@"video" waitUntilDone:NO];
                }
            }];
            [dataTask resume];
        }else if([type isEqualToString:@"audio"]){
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://ask.vipjingjie.com/moblie/checkIfEnoughMoney?type=video&userid=%@&targetid=%@",[RCIM sharedRCIM].currentUserInfo.userId,self.targetId]];
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                __weak typeof(&*self) weakSelf = self;
                //解析JSON
                NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                NSString *result = [accessDict objectForKey:@"result"];
                if([result isEqualToString:@"1"]){
                    [weakSelf performSelectorOnMainThread:@selector(startVoiceCall) withObject:nil waitUntilDone:NO];
                }else if([result isEqualToString:@"0"]){
                    [weakSelf performSelectorOnMainThread:@selector(alertSomething2) withObject:nil waitUntilDone:NO];
                    
                }else if([result isEqualToString:@"2"]){
                    [weakSelf performSelectorOnMainThread:@selector(alertSomething3:) withObject:@"voice" waitUntilDone:NO];
                }
            }];
            [dataTask resume];
        }else{
            //创建会话
            RCDChatViewController *chatViewController =
            [[RCDChatViewController alloc] init];
            chatViewController.conversationType = ConversationType_PRIVATE;
            
            chatViewController.targetId = self.targetId;
            [[RCDHttpTool shareInstance] getUserInfoByUserID:userid completion:^(RCUserInfo *user) {
                __weak typeof(&*self) weakSelf = self;
                NSString *title = user.name;
                chatViewController.title = title;
                chatViewController.userName = title;
                chatViewController.needPopToRootView = YES;
                chatViewController.displayUserNameInCell = NO;
                chatViewController.enableNewComingMessageIcon = YES; //开启消息提醒
                chatViewController.enableUnreadMessageIcon = YES;
                [weakSelf.navigationController pushViewController:chatViewController animated:YES];
            }];
            
        }
    };
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if([request.URL.absoluteString containsString:@"app"]){
        RCDUIBarButtonItem *leftbtn =
        [[RCDUIBarButtonItem alloc] initContainImage:[UIImage imageNamed:@"goback"]
                                      imageViewFrame:CGRectMake(0, 6, 24, 24)
                                         buttonTitle:nil
                                          titleColor:nil
                                          titleFrame:CGRectZero
                                         buttonFrame:CGRectMake(0, 6, 24, 24)
                                              target:self
                                              action:@selector(goback)];
        self.tabBarController.navigationItem.leftBarButtonItems = [leftbtn setTranslation:leftbtn translation:0];
    }else{
        self.tabBarController.navigationItem.leftBarButtonItems = nil;
    }
    return YES;
}

-(void)goback{
    [self.webView goBack];
}
-(void)swipeAction{
    [self.webView goBack];
}

//视频语音计费相关
-(void)checkCallState{
    if([[[RCCall sharedRCCall] currentCallSession]callStatus]==RCCallActive){
        [self.timer invalidate];
        self.timer = nil;
        self.y = 0;//y是用来记扣费次数的，用来算最终视频扣费
//        if([self videoAndAudioFee]){
//            self.timer2 = [NSTimer timerWithTimeInterval:60.0 target:self selector:@selector(videoAndAudioFee) userInfo:nil repeats:YES];
//            [[NSRunLoop currentRunLoop] addTimer:self.timer2 forMode:NSRunLoopCommonModes];
//            self.i=0;
//            self.timer3 = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
//            [[NSRunLoop currentRunLoop] addTimer:self.timer3 forMode:NSRunLoopCommonModes];
//        }
        dispatch_queue_t queue = dispatch_get_main_queue();
        
        // 创建GCD定时器
        dtimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        
        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC); // 开始时间
        uint64_t interval = 60 * NSEC_PER_SEC; // 时间间隔
        
        // 设置GCD定时器开始时间，间隔时间
        dispatch_source_set_timer(dtimer, start, interval, 0);
        
        // GCD定时器处理回调方法
        dispatch_source_set_event_handler(dtimer, ^{
            NSLog(@"---------%@", [NSThread currentThread]);
            [self videoAndAudioFee];
        });
        
        // GCD定时器启动，默认是关闭的
        dispatch_resume(dtimer);
        self.i=0;
        //            self.timer3 = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
        //            [[NSRunLoop currentRunLoop] addTimer:self.timer3 forMode:NSRunLoopCommonModes];
        dispatch_queue_t queue2 = dispatch_get_main_queue();
        
        // 创建GCD定时器
        dtimer2 = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue2);
        
        dispatch_time_t start2 = dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC); // 开始时间
        uint64_t interval2 = 1 * NSEC_PER_SEC; // 时间间隔
        
        // 设置GCD定时器开始时间，间隔时间
        dispatch_source_set_timer(dtimer2, start2, interval2, 0);
        
        // GCD定时器处理回调方法
        dispatch_source_set_event_handler(dtimer2, ^{
            NSLog(@"---------%@", [NSThread currentThread]);
            [self countTime];
        });
        
        // GCD定时器启动，默认是关闭的
        dispatch_resume(dtimer2);
    }
}
-(BOOL)videoAndAudioFee{
    NSString *path;
    if([[[RCCall sharedRCCall]currentCallSession]mediaType] == RCCallMediaAudio){
        path = [NSString stringWithFormat:@"https://ask.vipjingjie.com/moblie/audioFeePerMinutes?userid=%@&targetid=%@",[RCIM sharedRCIM].currentUserInfo.userId,self.targetId];
    }else{
        path = [NSString stringWithFormat:@"https://ask.vipjingjie.com/moblie/videoFeePerMinutes?userid=%@&targetid=%@",[RCIM sharedRCIM].currentUserInfo.userId,self.targetId];
    }
    NSURL * url = [NSURL URLWithString:path];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSString *result = [accessDict objectForKey:@"result"];
    NSString *price = [accessDict objectForKey:@"price"];
    self.videoPrice = price;
    if([result isEqualToString:@"1"]){
        self.y++;
        return YES;
    }else{
        //通话余额不足停止
        [[[RCCall sharedRCCall] currentCallSession] hangup];
//        [self.timer2 invalidate];
//        self.timer2 = nil;
        dispatch_source_cancel(dtimer); // 异步取消调度源
        dtimer = nil; // 将 dispatch_source_t 置为nil
        VideoEndView *veView = [[VideoEndView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        int s = (self.i)%60;
        int m = (self.i)/60;
        NSString *lan = [self getPreferredLanguage];
        if([lan containsString:@"zh"]){
            NSString *str = [NSString stringWithFormat:@"通话总时长：%d 分 %d 秒",m,s];
            [veView putTextLabel:str];
            NSString *str2 = [NSString stringWithFormat:@"计费标准：%@ 爱可币/分钟",price];
            [veView putTextLabel2:str2];
            int fee = self.y*[price intValue];
            NSString *str3 = [NSString stringWithFormat:@"计费总额：%d 爱可币",fee];
            [veView putTextLabel3:str3];
        }else{
            NSString *str = [NSString stringWithFormat:@"Time cost：%d m %ds",m,s];
            [veView putTextLabel:str];
            NSString *str2 = [NSString stringWithFormat:@"Price：%@ Excoins/Minute",price];
            [veView putTextLabel2:str2];
            int fee = self.y*[price intValue];
            NSString *str3 = [NSString stringWithFormat:@"Total Fee：%d Excoins",fee];
            [veView putTextLabel3:str3];
        }
        
        [self performSelectorOnMainThread:@selector(delayView:) withObject:veView waitUntilDone:YES];
        return NO;
        
    }
}
-(void)countTime{
    if([[[RCCall sharedRCCall] currentCallSession]callStatus]==RCCallActive){
        self.i++;
    }else{
        //通话人为停止
        //        [self.timer2 invalidate];
        //        self.timer2 = nil;
        dispatch_source_cancel(dtimer); // 异步取消调度源
        dtimer = nil; // 将 dispatch_source_t 置为nil
        VideoEndView *veView = [[VideoEndView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
        int s = (self.i)%60;
        int m = (self.i)/60;
        
        NSString *lan = [self getPreferredLanguage];
        if([lan isEqualToString:@"zh"]){
            NSString *str = [NSString stringWithFormat:@"通话总时长：%d 分 %d 秒",m,s];
            [veView putTextLabel:str];
            NSString *str2 = [NSString stringWithFormat:@"计费标准：%@  爱可币/分钟",self.videoPrice];
            [veView putTextLabel2:str2];
            int fee = self.y*[self.videoPrice intValue];
            NSString *str3 = [NSString stringWithFormat:@"计费总额：%d 爱可币",fee];
            [veView putTextLabel3:str3];
        }else{
            NSString *str = [NSString stringWithFormat:@"Time cost：%d m %d s",m,s];
            [veView putTextLabel:str];
            NSString *str2 = [NSString stringWithFormat:@"Price：%@ Excoins/Minute",self.videoPrice];
            [veView putTextLabel2:str2];
            int fee = self.y*[self.videoPrice intValue];
            NSString *str3 = [NSString stringWithFormat:@"Total Fee：%d Excoins",fee];
            [veView putTextLabel3:str3];
        }
        
        
        //        [self.timer3 invalidate];
        //        self.timer3 = nil;
        dispatch_source_cancel(dtimer2); // 异步取消调度源
        dtimer2 = nil; // 将 dispatch_source_t 置为nil
        //        [super.navigationController setNavigationBarHidden:YES animated:YES];
        //        self.tabBarController.tabBar.hidden = YES;
        [self performSelectorOnMainThread:@selector(delayView:) withObject:veView waitUntilDone:YES];
        
    }
    
}
-(void)delayView:(VideoEndView *)view{
    UIWindow *win = [[[UIApplication sharedApplication]delegate]window];
    [win addSubview:view];
    [win bringSubviewToFront:view];
}
-(void)hiddenNavigation{
//    [super.navigationController setNavigationBarHidden:NO animated:YES];
//    self.tabBarController.tabBar.hidden = NO;
}

- (NSString *)getCurrentLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
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
-(void)alertSomething2{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Notice", @"RongCloudKit",nil)
                                                        message:NSLocalizedStringFromTable(@"Your excoin is less for ten minutes, please add value", @"RongCloudKit",nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedStringFromTable(@"Confirm", @"RongCloudKit",nil)
                                              otherButtonTitles:nil, nil];
    [alertView show];
}
-(void)alertSomething3:(NSString *)type{
    if([type isEqualToString:@"video"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Notice", @"RongCloudKit",nil)
                                                            message:NSLocalizedStringFromTable(@"He is inconvenient for video calls now", @"RongCloudKit",nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedStringFromTable(@"Confirm", @"RongCloudKit",nil)
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Notice", @"RongCloudKit",nil)
                                                            message:NSLocalizedStringFromTable(@"He is inconvenient for voice calls now", @"RongCloudKit",nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedStringFromTable(@"Confirm", @"RongCloudKit",nil)
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}
- (void)writeToCache:(NSString *)urlStr

{
    
    NSString * htmlResponseStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlStr]encoding:NSUTF8StringEncoding error:Nil];
    
    //创建文件管理器
    
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    
    //获取document路径
    
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,      NSUserDomainMask, YES) objectAtIndex:0];
    
    [fileManager createDirectoryAtPath:[cachesPath stringByAppendingString:@"/Caches"]withIntermediateDirectories:YES attributes:nil error:nil];
    
    //写入路径
    
    NSString * path = [cachesPath stringByAppendingString:[NSString stringWithFormat:@"/Caches/%lu.html",(unsigned long)[urlStr hash]]];
    
    
    
    [htmlResponseStr writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}
@end

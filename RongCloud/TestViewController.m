//
//  TestViewController.m
//  SealTalk
//
//  Created by ChrisLaw on 2018/2/21.
//  Copyright © 2018年 RongCloud. All rights reserved.
//

#import "TestViewController.h"
#import "MeView.h"
#import "RCDCommonDefine.h"
#import "RCDUtilities.h"
#import <RongIMKit/RongIMKit.h>
#import "UIImageView+WebCache.h"
#import "RCDMeInfoTableViewController.h"
#import "RCDSettingsTableViewController.h"
#import "LinkViewController.h"
#import "UIColor+RCColor.h"
#import "AlipayViewController.h"
#import <WebKit/WebKit.h>
#import "RCDAboutRongCloudTableViewController.h"
@interface TestViewController ()<UIAlertViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UIButton *titleAlphaBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *vStartBtn;
@property (weak, nonatomic) IBOutlet UIButton *vEndBtn;
@property (weak, nonatomic) IBOutlet UIButton *aStartBtn;
@property (weak, nonatomic) IBOutlet UIButton *aEndBtn;
@property (weak, nonatomic) IBOutlet UIButton *mStartBtn;
@property (weak, nonatomic) IBOutlet UIButton *mEndBtn;
@property (weak, nonatomic) IBOutlet UIButton *vPriceBtn;
@property (weak, nonatomic) IBOutlet UIButton *aPriceBtn;
@property (weak, nonatomic) IBOutlet UIButton *mPriceBtn;
@property (weak, nonatomic) IBOutlet UIView *pickerBackground;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *doneEditBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelEditBtn;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UILabel *idLbl;
@property (assign,nonatomic) NSInteger tag;
@property (nonatomic,copy) NSString *tmp;
@property (nonatomic,strong) WKWebView *webView;
@end

@implementation TestViewController

#pragma mark - 时间按钮点击事件
//----------------------时间按钮点击事件------------------------
- (IBAction)videoStartClick:(UIButton *)sender {
    self.pickerBackground.hidden = NO;
    self.datePicker.hidden = NO;
    self.tag = sender.tag;
}
- (IBAction)videoEndClick:(UIButton *)sender {
    self.pickerBackground.hidden = NO;
    self.datePicker.hidden = NO;
    self.tag = sender.tag;
}
- (IBAction)audioStartClick:(UIButton *)sender {
    self.pickerBackground.hidden = NO;
    self.datePicker.hidden = NO;
    self.tag = sender.tag;
}
- (IBAction)audioEndClick:(UIButton *)sender {
    self.pickerBackground.hidden = NO;
    self.datePicker.hidden = NO;
    self.tag = sender.tag;
}
- (IBAction)messageStartClick:(UIButton *)sender {
    self.pickerBackground.hidden = NO;
    self.datePicker.hidden = NO;
    self.tag = sender.tag;
}
- (IBAction)messageEndClick:(UIButton *)sender {
    self.pickerBackground.hidden = NO;
    self.datePicker.hidden = NO;
    self.tag = sender.tag;
}
//-----------------------------------------------------------

#pragma mark - 价格按钮点击事件
//----------------------价格按钮点击事件------------------------
- (IBAction)videoPriceBtnClick:(UIButton *)sender {
    self.tag = sender.tag;
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Please Enter Aike", @"RongCloudKit",nil)
                                                         message:nil delegate:self
                                               cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @"RongCloudKit",
                                                                                            nil)
                                               otherButtonTitles:NSLocalizedStringFromTable(@"Confirm", @"RongCloudKit",
                                                                                            nil), nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    alertView.tag = 99;
    UITextField *priceField = [alertView textFieldAtIndex:0];
    priceField.keyboardType = UIKeyboardTypeNumberPad;
    priceField.placeholder = NSLocalizedStringFromTable(@"Setting Per Minute Aike", @"RongCloudKit",nil);
    [alertView show];
}
- (IBAction)audioPriceBtnClick:(UIButton *)sender {
    self.tag = sender.tag;
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Please Enter Aike", @"RongCloudKit",nil)
                                                         message:nil delegate:self
                                               cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @"RongCloudKit",
                                                                                            nil)
                                               otherButtonTitles:NSLocalizedStringFromTable(@"Confirm", @"RongCloudKit",
                                                                                            nil), nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    alertView.tag = 98;
    UITextField *priceField = [alertView textFieldAtIndex:0];
    priceField.keyboardType = UIKeyboardTypeNumberPad;
    priceField.placeholder = NSLocalizedStringFromTable(@"Setting Per Minute Aike", @"RongCloudKit",nil);
    [alertView show];
}
- (IBAction)messagePriceBtnClick:(UIButton *)sender {
    self.tag = sender.tag;
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Please Enter Aike", @"RongCloudKit",nil)
                                                         message:nil delegate:self
                                               cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @"RongCloudKit",
                                                                                            nil)
                                               otherButtonTitles:NSLocalizedStringFromTable(@"Confirm", @"RongCloudKit",
                                                                                            nil), nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    alertView.tag = 97;
    UITextField *priceField = [alertView textFieldAtIndex:0];
    priceField.keyboardType = UIKeyboardTypeNumberPad;
    priceField.placeholder = NSLocalizedStringFromTable(@"Setting Per Message Aike", @"RongCloudKit",nil);
    [alertView show];
}


//-----------------------------------------------------------

#pragma mark - 列表按钮点击事件
//---------------------列表按钮点击事件-------------------------
- (IBAction)myPacketBtnClick:(UIButton *)sender {
    AlipayViewController *alipayVC = [[AlipayViewController alloc]init];
    [self.navigationController  pushViewController:alipayVC animated:YES];
}

- (IBAction)personalInfoBtnClick:(UIButton *)sender {
//    CGRect rectOfStatusbar = [[UIApplication sharedApplication] statusBarFrame];
//    CGRect rectOFNavigationbar = self.navigationController.navigationBar.frame;
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    NSString *str1 = [NSString stringWithFormat:@"https://ask.vipjingjie.com/moblie/app/selfData?userid=%@",[RCIM sharedRCIM].currentUserInfo.userId];
    NSString *str2 = [NSString stringWithFormat:@"&locate=%@",[self getPreferredLanguage]];
    NSURL *url = [NSURL URLWithString:[str1 stringByAppendingString:str2]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.frame = [UIScreen mainScreen].bounds;
    [vc.view addSubview:self.webView];
    [self showViewController:vc sender:nil];
}
- (IBAction)toVerifyBtnClick:(UIButton *)sender {
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    NSString *str1 = [NSString stringWithFormat:@"https://ask.vipjingjie.com/moblie/app/selfData?userid=%@",[RCIM sharedRCIM].currentUserInfo.userId];
    NSString *str2 = [NSString stringWithFormat:@"&locate=%@",[self getPreferredLanguage]];
    NSURL *url = [NSURL URLWithString:[str1 stringByAppendingString:str2]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.frame = [UIScreen mainScreen].bounds;
    [vc.view addSubview:self.webView];
    [self showViewController:vc sender:nil];
}

- (IBAction)accountSettingBtnClick:(UIButton *)sender {
    RCDSettingsTableViewController *vc = [[RCDSettingsTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)inviteBtnClick:(UIButton *)sender {
//    CGRect rectOfStatusbar = [[UIApplication sharedApplication] statusBarFrame];
//    CGRect rectOFNavigationbar = self.navigationController.navigationBar.frame;
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    NSString *str1 = [NSString stringWithFormat:@"https://ask.vipjingjie.com/moblie/app/commend_qcode?userid=%@",[RCIM sharedRCIM].currentUserInfo.userId];
    NSString *str2 = [NSString stringWithFormat:@"&locate=%@",[self getPreferredLanguage]];
    NSURL *url = [NSURL URLWithString:[str1 stringByAppendingString:str2]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.frame = [UIScreen mainScreen].bounds;
    [vc.view addSubview:self.webView];
    [self showViewController:vc sender:nil];
}

- (IBAction)adviceBtnClick:(UIButton *)sender {
    CGRect rectOfStatusbar = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectOFNavigationbar = self.navigationController.navigationBar.frame;
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height-rectOFNavigationbar.size.height-rectOfStatusbar.size.height)];
    NSString *str1 = [NSString stringWithFormat:@"https://ask.vipjingjie.com/moblie/app/feedback?userid=%@",[RCIM sharedRCIM].currentUserInfo.userId];
    NSString *str2 = [NSString stringWithFormat:@"&locate=%@",[self getPreferredLanguage]];
    NSURL *url = [NSURL URLWithString:[str1 stringByAppendingString:str2]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.frame = [UIScreen mainScreen].bounds;
    [vc.view addSubview:self.webView];
    [self showViewController:vc sender:nil];
}

- (IBAction)aboutBtnClick:(UIButton *)sender {
    RCDAboutRongCloudTableViewController *arcVC = [[RCDAboutRongCloudTableViewController alloc]init];
    [self showViewController:arcVC sender:nil];
}

//-----------------------------------------------------------

#pragma mark - 其它点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 99:
            if(buttonIndex == 1){
                UITextField *priceField = [alertView textFieldAtIndex:0];
                UIButton *button = (UIButton *)[self.view viewWithTag:self.tag];
                if([self isPureInt:priceField.text]){
                    self.tmp = priceField.text;
                    NSString *userid = [RCIM sharedRCIM].currentUserInfo.userId;
                    NSString *time = [priceField.text stringByReplacingOccurrencesOfString:@":" withString:@""];
                    NSString *path = [NSString stringWithFormat:@"http://ask.vipjingjie.com/moblie/updateSchedule?userid=%@&time=%@&tag=%ld",userid,time,self.tag];
                    NSURL *url = [NSURL URLWithString:path];
                    NSURLSession *session = [NSURLSession sharedSession];
                    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        __weak typeof(&*self) weakSelf = self;
                        //解析JSON
                        NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                        NSString *result = [accessDict objectForKey:@"result"];
                        if([result isEqualToString:@"1"]){
                            //[button setTitle:self.tmp forState:UIControlStateNormal];
                            [weakSelf performSelectorOnMainThread:@selector(updateButton:) withObject:@(self.tag) waitUntilDone:YES];
                        }else{
                            [weakSelf performSelector:@selector(alertError) withObject:nil afterDelay:0];
                        }
                    }];
                    [dataTask resume];
                }
                
            }
            break;
        case 98:
            if(buttonIndex == 1){
                UITextField *priceField = [alertView textFieldAtIndex:0];
                UIButton *button = (UIButton *)[self.view viewWithTag:self.tag];
                if([self isPureInt:priceField.text]){
                    
                    //--------------------接口----------------------
                    self.tmp = priceField.text;
                    NSString *userid = [RCIM sharedRCIM].currentUserInfo.userId;
                    NSString *time = [priceField.text stringByReplacingOccurrencesOfString:@":" withString:@""];
                    NSString *path = [NSString stringWithFormat:@"http://ask.vipjingjie.com/moblie/updateSchedule?userid=%@&time=%@&tag=%ld",userid,time,self.tag];
                    NSURL *url = [NSURL URLWithString:path];
                    NSURLSession *session = [NSURLSession sharedSession];
                    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        __weak typeof(&*self) weakSelf = self;
                        //解析JSON
                        NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                        NSString *result = [accessDict objectForKey:@"result"];
                        if([result isEqualToString:@"1"]){
                            //[button setTitle:self.tmp forState:UIControlStateNormal];
                            [weakSelf performSelectorOnMainThread:@selector(updateButton:) withObject:@(self.tag) waitUntilDone:YES];
                        }else{
                            [weakSelf performSelector:@selector(alertError) withObject:nil afterDelay:0];
                        }
                    }];
                    [dataTask resume];
                    //----------------------------------------------
                }
            }
            break;
        case 97:
            if(buttonIndex == 1){
                UITextField *priceField = [alertView textFieldAtIndex:0];
                UIButton *button = (UIButton *)[self.view viewWithTag:self.tag];
                if([self isPureInt:priceField.text]){
                    self.tmp = priceField.text;
                    NSString *userid = [RCIM sharedRCIM].currentUserInfo.userId;
                    NSString *time = [priceField.text stringByReplacingOccurrencesOfString:@":" withString:@""];
                    NSString *path = [NSString stringWithFormat:@"http://ask.vipjingjie.com/moblie/updateSchedule?userid=%@&time=%@&tag=%ld",userid,time,self.tag];
                    NSURL *url = [NSURL URLWithString:path];
                    NSURLSession *session = [NSURLSession sharedSession];
                    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        __weak typeof(&*self) weakSelf = self;
                        //解析JSON
                        NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                        NSString *result = [accessDict objectForKey:@"result"];
                        if([result isEqualToString:@"1"]){
                            //[button setTitle:self.tmp forState:UIControlStateNormal];
                            [weakSelf performSelectorOnMainThread:@selector(updateButton:) withObject:@(self.tag) waitUntilDone:YES];
                        }else{
                            [weakSelf performSelector:@selector(alertError) withObject:nil afterDelay:0];
                        }
                    }];
                    [dataTask resume];
                }
            }
            break;
        default:
            break;
    }
    
}


//时间选择完毕
- (IBAction)doneBtnClick:(id)sender {
    
    NSDate *date = self.datePicker.date;
    NSDateFormatter *myFormat = [[NSDateFormatter alloc]init];
    [myFormat setDateFormat:@"HH:mm"];
    NSString *final = [myFormat stringFromDate:date];
    NSLog(@"%@",final);
    NSString *finalStr = [final stringByReplacingOccurrencesOfString:@":" withString:@""];
    if([self checkTimeIfValid:self.tag :finalStr]){
//        UIButton *button = (UIButton *)[self.view viewWithTag:self.tag];
//        [button setTitle:final forState:UIControlStateNormal];
        self.pickerBackground.hidden = YES;
        self.datePicker.hidden = YES;
        
        //----------------接口------------------
        self.tmp = final;
        NSString *userid = [RCIM sharedRCIM].currentUserInfo.userId;
        NSString *path = [NSString stringWithFormat:@"http://ask.vipjingjie.com/moblie/updateSchedule?userid=%@&time=%@&tag=%ld",userid,finalStr,self.tag];
        NSURL *url = [NSURL URLWithString:path];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            __weak typeof(&*self) weakSelf = self;
            //解析JSON
            NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSString *result = [accessDict objectForKey:@"result"];
            if([result isEqualToString:@"1"]){
                //[button setTitle:self.tmp forState:UIControlStateNormal];
                [weakSelf performSelectorOnMainThread:@selector(updateButton:) withObject:@(self.tag) waitUntilDone:YES];
            }else{
                [weakSelf performSelector:@selector(alertError) withObject:nil afterDelay:0];
            }
        }];
        [dataTask resume];
        //--------------------------------------
        
    }else{
        UIAlertView *alertView =
        [
         [UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Modification Failure", @"RongCloudKit",nil)
         message:NSLocalizedStringFromTable(@"Invalid Date", @"RongCloudKit",nil)
         delegate:nil
         cancelButtonTitle:NSLocalizedStringFromTable(@"Confirm", @"RongCloudKit",nil)
         otherButtonTitles:nil];
        [alertView show];
    }
    
}
- (IBAction)cancelBtnClick:(id)sender {
    self.pickerBackground.hidden = YES;
    self.datePicker.hidden = YES;
}

- (IBAction)pickerValueChanged:(UIDatePicker *)sender {
    NSLog(@"%@",sender.date);
}


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *portraitUrl = [DEFAULTS stringForKey:@"userPortraitUri"];
    if ([portraitUrl isEqualToString:@""]) {
        portraitUrl = [RCDUtilities defaultUserPortrait:[RCIM sharedRCIM].currentUserInfo];
    }
    NSURL *iconUrl = [NSURL URLWithString:portraitUrl];
    NSData *iconData = [NSData dataWithContentsOfURL:iconUrl];
    UIImage *iconImage = [UIImage imageWithData:iconData];
    [self.titleImage setImage:iconImage];
    self.titleName.text = [RCIM sharedRCIM].currentUserInfo.name;
    //接口
    NSString *path = [NSString stringWithFormat:@"http://ask.vipjingjie.com/moblie/getSchedule?userid=%@",[RCIM sharedRCIM].currentUserInfo.userId];
    NSURL *url = [NSURL URLWithString:path];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __weak typeof(&*self) weakSelf = self;
        //解析JSON
        NSArray *accessArr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        [weakSelf performSelectorOnMainThread:@selector(loadSchedule:) withObject:accessArr waitUntilDone:YES];
    }];
    [dataTask resume];
}

#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    self.scrollView.contentSize = CGSizeMake(375, 800);
    NSString *urlStr = [NSString stringWithFormat:@"https://ask.vipjingjie.com/moblie/personalAike?userid=%@",[RCIM sharedRCIM].currentUserInfo.userId];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __weak typeof(&*self) weakSelf = self;
        NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSString *result = [accessDict objectForKey:@"result"];
        if([result isEqualToString:@"1"]){
            NSString *aike = [accessDict objectForKey:@"aike"];
            [weakSelf performSelectorOnMainThread:@selector(updateText:) withObject:aike waitUntilDone:YES];
        }
    }];
    [dataTask resume];
}

-(void)updateText:(NSString *)aike{
    NSString *title = NSLocalizedStringFromTable(@"MeTableViewTabBarTitle", @"RongCloudKit",
                                                 nil);
    NSString *remain = NSLocalizedStringFromTable(@"remain", @"RongCloudKit",
                                                  nil);
    NSString *str = [NSString stringWithFormat:@"%@(%@:%@)",title,remain,aike];
    self.tabBarController.navigationItem.title = str;
}

//检测时间是否可用
-(BOOL)checkTimeIfValid:(NSInteger *)tag:(NSString*)value{
    BOOL result;
    NSString *tmp = [NSString stringWithFormat:@"%ld",tag];
    int number = [tmp intValue];
    if(number%2==0){
        UIButton *smallBtn = (UIButton *)[self.view viewWithTag:number-1];
        NSString *bigTime = value;
        NSString *smallTime = smallBtn.titleLabel.text;
        if([smallTime containsString:@":"]){
            int bigInt = [[self timeStrFilter:bigTime] intValue];
            int smallInt = [[self timeStrFilter:smallTime] intValue];
            if(bigInt>smallInt){
                result = YES;
            }else{
                result = NO;
            }
        }else{
            result = YES;
        }
    }else{
        UIButton *bigBtn = (UIButton *)[self.view viewWithTag:number+1];
        NSString *smallTime = value;
        NSString *bigTime = bigBtn.titleLabel.text;
        if([bigTime containsString:@":"]){
            int bigInt = [[self timeStrFilter:bigTime] intValue];
            int smallInt = [[self timeStrFilter:smallTime] intValue];
            if(bigInt>smallInt){
                result = YES;
            }else{
                result = NO;
            }
        }else{
            result = YES;
        }
    }
    return result;
}
-(NSString*)timeStrFilter:(NSString*)time{
    NSString *rst = [time stringByReplacingOccurrencesOfString:@":" withString:@""];
    return rst;
}
-(void)alertError{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Server Error", @"RongCloudKit",nil)
                                                         message:nil delegate:nil
                                               cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @"RongCloudKit",nil)
                                               otherButtonTitles:NSLocalizedStringFromTable(@"Confirm", @"RongCloudKit",nil), nil];
    [alertView show];
}
//-(void)tapTitleView{
//    RCDMeInfoTableViewController *vc = [[RCDMeInfoTableViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//-(void)updateTapVAction:(UITapGestureRecognizer *)tapGR
//{
//    [self.titleView resignFirstResponder];
//}
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
-(void)updateButton:(NSNumber *)tag{
    UIButton *button = (UIButton *)[self.view viewWithTag:[tag integerValue]];
    [button setTitle:self.tmp forState:UIControlStateNormal];
}
-(void)loadSchedule:(NSArray*)accessArr{
    for(int i = 0;i<accessArr.count;i++){
        UIButton *button = (UIButton *)[self.view viewWithTag:i+1];
        [button setTitle:accessArr[i] forState:UIControlStateNormal];
    }
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
@end

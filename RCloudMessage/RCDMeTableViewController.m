//
//  RCDMeTableViewController.m
//  RCloudMessage
//
//  Created by Liv on 14/11/28.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import "RCDMeTableViewController.h"
#import "AFHttpTool.h"
#import "DefaultPortraitView.h"
#import "RCDChatViewController.h"
#import "RCDCommonDefine.h"
#import "RCDCustomerServiceViewController.h"
#import "RCDHttpTool.h"
#import "RCDRCIMDataSource.h"
#import "RCDUtilities.h"
#import "RCDataBaseManager.h"
#import "UIColor+RCColor.h"
#import "UIImageView+WebCache.h"
#import <RongIMLib/RongIMLib.h>
#import "RCDSettingsTableViewController.h"
#import "RCDMeInfoTableViewController.h"
#import "RCDAboutRongCloudTableViewController.h"
#import "RCDBaseSettingTableViewCell.h"
#import "RCDMeDetailsCell.h"
#import "RCDMeCell.h"
#import "MyMoneyViewController.h"
/* RedPacket_FTR */
#import <JrmfWalletKit/JrmfWalletKit.h>

#define SERVICE_ID @"KEFU146001495753714"
#define SERVICE_ID_XIAONENG @"kf_4029_1483495902343"
#define SERVICE_ID_JIAXIN @"xgs"

@interface RCDMeTableViewController ()
@property(nonatomic) BOOL hasNewVersion;
@property(nonatomic) NSString *versionUrl;
@property(nonatomic, strong) NSString *versionString;

@property(nonatomic, strong) NSURLConnection *connection;
@property(nonatomic, strong) NSMutableData *receiveData;
@property (nonatomic,strong) RCDMeCell *myCell;
@end

@implementation RCDMeTableViewController {
    UIImage *userPortrait;
    BOOL isSyncCurrentUserInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f0f0f6" alpha:1.f];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.navigationController.navigationBar.tintColor =
    [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setUserPortrait:)
                                                 name:@"setCurrentUserPortrait"
                                               object:nil];
    
    isSyncCurrentUserInfo = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *title = NSLocalizedStringFromTable(@"MeTableViewTabBarTitle", @"RongCloudKit",
                                                 nil);
    self.tabBarController.navigationItem.title = title;
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    self.tabBarController.navigationItem.rightBarButtonItems = nil;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows;
    switch (section) {
        case 0:
            rows = 1;
            break;
            
        case 1:
            /* RedPacket_FTR */ //添加了红包，row+=1；
            rows = 2;
            break;
            
        case 2:
            rows = 5;
            break;
            
        default:
            break;
    }
    return rows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reusableCellWithIdentifier = @"RCDMeCell";
    RCDMeCell *cell = [self.tableView
                       dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
    
    static NSString *detailsCellWithIdentifier = @"RCDMeDetailsCell";
    RCDMeDetailsCell *detailsCell = [self.tableView
                                     dequeueReusableCellWithIdentifier:detailsCellWithIdentifier];
    if (cell == nil) {
        cell = [[RCDMeCell alloc] init];
    }
    if (detailsCell == nil) {
        NSString *portraitUrl = [DEFAULTS stringForKey:@"userPortraitUri"];
        if ([portraitUrl isEqualToString:@""]) {
            portraitUrl = [RCDUtilities defaultUserPortrait:[RCIM sharedRCIM].currentUserInfo];
        }
//        detailsCell = [[RCDMeDetailsCell alloc]
//                initWithLeftImageStr:nil
//                leftImageSize:CGSizeMake(65, 65)
//                rightImaeStr:@"right"
//                rightImageSize:CGSizeZero];
//        detailsCell.leftImageCornerRadius = 5.f;
//        detailsCell.leftLabel.text = [DEFAULTS stringForKey:@"userNickName"];
        detailsCell = [[RCDMeDetailsCell alloc] init];
    }
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    return detailsCell;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    self.myCell = cell;
                    [self.myCell setCellWithImageName:@"switch" labelName:@"切换状态"];
                    self.myCell.rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right"]];
                }
                    break;
                    
                    /* RedPacket_FTR */
                case 1: {
                    [cell setCellWithImageName:@"wallet" labelName:@"我的钱包"];
                }
                default:
                    break;
            }
            return cell;
        }
            break;
            
        case 2: {
            switch (indexPath.row) {
                case 0:{
                    [cell setCellWithImageName:@"identify" labelName:@"个人资料"];
                    return cell;
                }
                    break;
                    
                case 1:{
                    [cell setCellWithImageName:@"invite" labelName:@"邀请好友"];
                    return cell;
                }
                    break;
                case 2:{
                    [cell setCellWithImageName:@"setting_up" labelName:@"帐号设置"];
                    return cell;
                }
                case 3:{
                    [cell setCellWithImageName:@"sevre_inactive" labelName:@"任何意见"];
                    return cell;
                }
                    break;
                case 4:{
                    [cell setCellWithImageName:@"about_rongcloud" labelName:@"关于 淘信子"];
                    NSString *isNeedUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"isNeedUpdate"];
                    if ([isNeedUpdate isEqualToString:@"YES"]) {
                        [cell addRedpointImageView];
                    }
                    return cell;
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height;
    switch (indexPath.section) {
        case 0:{
            height = 88.f;
        }
            break;
            
        default:
            height = 44.f;
            break;
    }
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            RCDMeInfoTableViewController *vc = [[RCDMeInfoTableViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    [self showAlertView];
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                }
                    break;
                    /* RedPacket_FTR */ //open my wallet
                case 1: {
                    //[JrmfWalletSDK openWallet];
                    MyMoneyViewController *mmc = [[MyMoneyViewController alloc]init];
                    [self.navigationController pushViewController:mmc animated:YES];
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 2: {
            switch (indexPath.row) {
                case 0: {
                    [self chatWithCustomerService:SERVICE_ID];
                }
                    break;
                    
                case 1: {
                    RCDAboutRongCloudTableViewController *vc = [[RCDAboutRongCloudTableViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 2:{
                    RCDSettingsTableViewController *vc = [[RCDSettingsTableViewController alloc] init];
                    [self.navigationController pushViewController:vc
                                                         animated:YES];
                }
                    break;
                case 3: {
                    [self chatWithCustomerService:SERVICE_ID_XIAONENG];
                }
                    break;
                case 4: {
                    [self chatWithCustomerService:SERVICE_ID_JIAXIN];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    return 15.f;
}

- (void)setUserPortrait:(NSNotification *)notifycation {
    userPortrait = [notifycation object];
}

- (void)chatWithCustomerService:(NSString *)kefuId {
    RCDCustomerServiceViewController *chatService =
    [[RCDCustomerServiceViewController alloc] init];
    
    // live800  KEFU146227005669524   live800的客服ID
    // zhichi   KEFU146001495753714   智齿的客服ID
    chatService.conversationType = ConversationType_CUSTOMERSERVICE;
    
    chatService.targetId = kefuId;
    
    //上传用户信息，nickname是必须要填写的
    RCCustomerServiceInfo *csInfo = [[RCCustomerServiceInfo alloc] init];
    csInfo.userId = [RCIMClient sharedRCIMClient].currentUserInfo.userId;
    csInfo.nickName = @"昵称";
    csInfo.loginName = @"登录名称";
    csInfo.name = [RCIMClient sharedRCIMClient].currentUserInfo.name;
    csInfo.grade = @"11级";
    csInfo.gender = @"男";
    csInfo.birthday = @"2016.5.1";
    csInfo.age = @"36";
    csInfo.profession = @"software engineer";
    csInfo.portraitUrl =
    [RCIMClient sharedRCIMClient].currentUserInfo.portraitUri;
    csInfo.province = @"beijing";
    csInfo.city = @"beijing";
    csInfo.memo = @"这是一个好顾客!";
    
    csInfo.mobileNo = @"13800000000";
    csInfo.email = @"test@example.com";
    csInfo.address = @"北京市北苑路北泰岳大厦";
    csInfo.QQ = @"88888888";
    csInfo.weibo = @"my weibo account";
    csInfo.weixin = @"myweixin";
    
    csInfo.page = @"卖化妆品的页面来的";
    csInfo.referrer = @"10001";
    csInfo.enterUrl = @"testurl";
    csInfo.skillId = @"技能组";
    csInfo.listUrl = @[@"用户浏览的第一个商品Url",
                       @"用户浏览的第二个商品Url"];
    csInfo.define = @"自定义信息";
    
    chatService.csInfo = csInfo;
    chatService.title = @"客服";
    
    [self.navigationController pushViewController:chatService animated:YES];
}
-(void)showAlertView{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"切换状态"
                                                                   message:@"切换账号在线状态"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"在线" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self switchApi:@(1)];
                                                          }];
    UIAlertAction* defaultAction2 = [UIAlertAction actionWithTitle:@"离开" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self switchApi:@(0)];
                                                          }];
    UIAlertAction* defaultAction3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [alert addAction:defaultAction2];
    [alert addAction:defaultAction3];
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)apiAlertView{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"服务器错误" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)switchApi:(NSNumber *)status{
    NSURL *url = [NSURL URLWithString:@""];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __weak typeof(&*self) weakSelf = self;
        if(error){
            [weakSelf apiAlertView];
            weakSelf.myCell.rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cross"]];
            return;
        }
        //解析JSON
        NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSString *result = [accessDict objectForKey:@"result"];
        if([result isEqualToString:@"1"]){
            
        }else{
            weakSelf.myCell.rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cross"]];
        }
    }];
    [dataTask resume];
}
@end



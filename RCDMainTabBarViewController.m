//
//  RCDMainTabBarViewController.m
//  RCloudMessage
//
//  Created by Jue on 16/7/30.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import "RCDMainTabBarViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDSquareTableViewController.h"
#import "RCDChatViewController.h"
#import "RCDChatListViewController.h"
#import "RCDContactViewController.h"
#import "RCDMeTableViewController.h"
#import "QuanViewController.h"
#import "AFHttpTool.h"
#import "RCDUserInfo.h"
#import "RCDRCIMDataSource.h"
#import "ServiceViewController.h"
#import "TestViewController.h"
#import "UIColor+RCColor.h"
@interface RCDMainTabBarViewController ()

@property NSUInteger previousIndex;

@end
NSString *title;
NSString *iconUrl;
NSString *iconUrl2;
@implementation RCDMainTabBarViewController

+ (RCDMainTabBarViewController *)shareInstance {
  static RCDMainTabBarViewController *instance = nil;
  static dispatch_once_t predicate;
  dispatch_once(&predicate, ^{
    instance = [[[self class] alloc] init];
  });
  return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIApplication sharedApplication].statusBarHidden=NO;
    [self setControllers];
    [self setTabBarItems];
    self.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeSelectedIndex:)
                                                 name:@"ChangeTabBarIndex"
                                               object:nil];
        NSUserDefaults *TimeOfBootCount=[NSUserDefaults standardUserDefaults];
    self.tabBarController.tabBar.tintColor  = [UIColor colorWithHexString:@"CFB065" alpha:1];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setControllers {
  RCDChatListViewController *chatVC = [[RCDChatListViewController alloc] init];
    ServiceViewController *homeVC = [[ServiceViewController alloc]init];
  //RCDContactViewController *contactVC = [[RCDContactViewController alloc] init];
  
//  RCDSquareTableViewController *discoveryVC = [[RCDSquareTableViewController alloc] init];
   
 // RCDMeTableViewController *meVC = [[RCDMeTableViewController alloc] init];
    UIStoryboard *meStoryboard = [UIStoryboard storyboardWithName:@"MeView" bundle:nil];
    
    TestViewController *aboutVC = [meStoryboard instantiateViewControllerWithIdentifier:@"MeView"];
//  QuanViewController *quanVc =[[QuanViewController alloc] init];
  self.viewControllers = @[homeVC,chatVC,aboutVC];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[RCDChatListViewController class]]) {
            RCDChatListViewController *chatListVC = (RCDChatListViewController *)obj;
            [chatListVC updateBadgeValueForTabBarItem];
        }
    }];
}

-(void)setTabBarItems {
  [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      if([obj isKindOfClass:[ServiceViewController class]]){
          NSString *title = NSLocalizedStringFromTable(@"ServiceViewTabBarTitle", @"RongCloudKit",
                                                       nil);
          
          obj.tabBarItem.title = title;
          obj.tabBarController.tabBar.tintColor = [UIColor colorWithHexString:@"CFB065" alpha:1];
          obj.tabBarItem.image = [[UIImage imageNamed:@"service"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
          obj.tabBarItem.selectedImage = [[UIImage imageNamed:@"service_hover"]
                                          imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
      }else if ([obj isKindOfClass:[RCDChatListViewController class]]) {
          NSString *title = NSLocalizedStringFromTable(@"ChatListViewTabBarTitle", @"RongCloudKit",
                                                       nil);
          obj.tabBarItem.title = title;
          obj.tabBarController.tabBar.tintColor = [UIColor colorWithHexString:@"CFB065" alpha:1];
          obj.tabBarItem.image = [[UIImage imageNamed:@"icon_chat"]
                                  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
          obj.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_chat_hover"]
                                          imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
      } else if ([obj isKindOfClass:[TestViewController class]]){
          NSString *title = NSLocalizedStringFromTable(@"MeTableViewTabBarTitle", @"RongCloudKit",
                                                       nil);
      obj.tabBarItem.title = title;
          obj.tabBarController.tabBar.tintColor = [UIColor colorWithHexString:@"CFB065" alpha:1];
      obj.tabBarItem.image = [[UIImage imageNamed:@"icon_me"]
                              imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
      obj.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_me_hover"]
                                      imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
      NSLog(@"Unknown TabBarController");
    }
  }];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
  NSUInteger index = tabBarController.selectedIndex;
  [RCDMainTabBarViewController shareInstance].selectedTabBarIndex = index;
  switch (index) {
    case 0:
    {
      if (self.previousIndex == index) {
        //判断如果有未读数存在，发出定位到未读数会话的通知
        if ([[RCIMClient sharedRCIMClient] getTotalUnreadCount] > 0) {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"GotoNextCoversation" object:nil];
        }
        self.previousIndex = index;
      }
      self.previousIndex = index;
    }
      break;
      
    case 1:
      self.previousIndex = index;
      break;
      
    case 2:
      self.previousIndex = index;
      break;
      
    case 3:
      self.previousIndex = index;
      break;
      
    default:
      break;
  }
}

-(void)changeSelectedIndex:(NSNotification *)notify {
  NSInteger index = [notify.object integerValue];
  self.selectedIndex = index;
}
@end

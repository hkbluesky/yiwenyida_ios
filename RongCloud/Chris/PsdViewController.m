//
//  PsdViewController.m
//  SealTalk
//
//  Created by ChrisLaw on 2018/3/22.
//  Copyright © 2018年 RongCloud. All rights reserved.
//

#import "PsdViewController.h"
#import "RCDLoginViewController.h"
#import "RCDRegisterViewController.h"
@interface PsdViewController ()

@end

@implementation PsdViewController
- (IBAction)SignupClick:(id)sender {
    RCDRegisterViewController *rVC = [[RCDRegisterViewController alloc]init];
    [self.navigationController pushViewController:rVC animated:YES];
}
- (IBAction)LoginClick:(id)sender {
    RCDLoginViewController *loginVC = [[RCDLoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

//
//  AVViewController.m
//  SealTalk
//
//  Created by ChrisLaw on 2018/2/28.
//  Copyright © 2018年 RongCloud. All rights reserved.
//

#import "AVViewController.h"
#import "VideoEndView.h"
@interface AVViewController ()
@end

@implementation AVViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)btnClick:(id)sender {
    [self popoverPresentationController];
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

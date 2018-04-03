//
//  AppInfoViewController.m
//  SealTalk
//
//  Created by ChrisLaw on 2018/4/3.
//  Copyright © 2018年 RongCloud. All rights reserved.
//

#import "AppInfoViewController.h"

@interface AppInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AppInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.selectedRange = NSMakeRange(0, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
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

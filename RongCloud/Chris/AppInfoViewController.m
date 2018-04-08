//
//  AppInfoViewController.m
//  SealTalk
//
//  Created by ChrisLaw on 2018/4/3.
//  Copyright © 2018年 RongCloud. All rights reserved.
//

#import "AppInfoViewController.h"

@interface AppInfoViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *goBackBtn;

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
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.goBackBtn.hidden = YES;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.goBackBtn.hidden = NO;
}
- (IBAction)goBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

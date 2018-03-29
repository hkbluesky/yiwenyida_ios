//
//  LaunchViewController.m
//  SealTalk
//
//  Created by ChrisLaw on 2018/3/16.
//  Copyright © 2018年 RongCloud. All rights reserved.
//

#import "LaunchViewController.h"
#import "RCDLoginViewController.h"
@interface LaunchViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *goBtn;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;



@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width*3, self.view.frame.size.height);
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 0;
    [self.goBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.goBtn.layer setBorderWidth:3];
    [self.goBtn.layer setMasksToBounds:YES];
    self.scrollView.delegate = self;
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goBtnClick:(id)sender {
    RCDLoginViewController *loginVC = [[RCDLoginViewController alloc]init];
    [self showViewController:loginVC sender:nil];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index=fabs(self.scrollView.contentOffset.x)/self.scrollView.frame.size.width;
    if(index==2){
        self.goBtn.hidden = NO;
    }else{
        self.goBtn.hidden = YES;
    }
    self.pageControl.currentPage=index;
}
-(void)dealloc{
    self.navigationController.navigationBarHidden = NO;
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

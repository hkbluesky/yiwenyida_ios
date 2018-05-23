//
//  VideoEndView.m
//  SealTalk
//
//  Created by ChrisLaw on 2018/1/27.
//  Copyright © 2018年 RongCloud. All rights reserved.
//

#import "VideoEndView.h"
@interface VideoEndView()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel2;
@property (weak, nonatomic) IBOutlet UILabel *textLabel3;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end
@implementation VideoEndView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self==[super initWithFrame:frame]){
        self=[[[NSBundle mainBundle] loadNibNamed:@"VideoEndView" owner:self options:nil] lastObject];
        
        self.frame=frame;//这个必须要设置，根据不同平台设置View的大小；
    }
    return self;
}

- (IBAction)btnClick:(UIButton *)sender {
    NSNotification *notification =[NSNotification notificationWithName:@"removeVideoEndView" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self removeFromSuperview];
    
}

-(void)putTextLabel:(NSString *)text{
    _textLabel.text = text;
}
-(void)putTextLabel2:(NSString *)text{
    _textLabel2.text = text;
}
-(void)putTextLabel3:(NSString *)text{
    _textLabel3.text = text;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

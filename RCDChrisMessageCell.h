//
//  RCDChrisMessageCell.h
//  SealTalk
//
//  Created by ChrisLaw on 2017/11/10.
//  Copyright © 2017年 RongCloud. All rights reserved.
//
#import "RCChrisMessage.h"
#import <RongIMKit/RongIMKit.h>

@interface RCDChrisMessageCell : RCMessageCell


/**
 * 消息显示Label
 */
@property(strong, nonatomic) UILabel *textLabel;

/**
 * 消息背景
 */
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;

/**
 * 设置消息数据模型
 *
 * @param model 消息数据模型
 */
- (void)setDataModel:(RCMessageModel *)model;
@end

//
//  RCChrisMessage.h
//  SealTalk
//
//  Created by ChrisLaw on 2017/11/10.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

#define RCDChrisMessageTypeIdentifier @"ChrisMsg"

@interface RCChrisMessage : RCMessageContent <NSCoding>

/*!
 文本消息的内容
 */
@property(nonatomic, strong) NSString *content;

/*!
 文本消息的附加信息
 */
@property(nonatomic, strong) NSString *extra;


/*!
 初始化文本消息
 
 @param content 文本消息的内容
 @return        文本消息对象
 */
+ (instancetype)messageWithContent:(NSString *)content;

@end

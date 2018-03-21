//
//  RCDChrisMessageCell.m
//  SealTalk
//
//  Created by ChrisLaw on 2017/11/10.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "RCDChrisMessageCell.h"
#import "LinkViewController.h"
#import <sys/utsname.h>
#define Test_Message_Font_Size 26

@implementation RCDChrisMessageCell
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    RCChrisMessage *message = (RCChrisMessage *)model.content;
    CGSize size = [RCDChrisMessageCell getBubbleBackgroundViewSize:message];
    
    CGFloat __messagecontentview_height = 92;
    __messagecontentview_height += extraHeight;
    
    return CGSizeMake(collectionViewWidth, __messagecontentview_height);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.messageContentView addSubview:self.bubbleBackgroundView];
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.textLabel setFont:[UIFont systemFontOfSize:Test_Message_Font_Size]];
    self.textLabel.numberOfLines = 0;
    [self.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.textLabel setTextAlignment:NSTextAlignmentCenter];
    [self.textLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [self.textLabel setTextColor:[UIColor blackColor]];
    //[self.bubbleBackgroundView addSubview:self.textLabel];
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(longPressed:)];
    [self.bubbleBackgroundView addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *textMessageTap = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(tapTextMessage:)];
    textMessageTap.numberOfTapsRequired = 1;
    textMessageTap.numberOfTouchesRequired = 1;
    [self.textLabel addGestureRecognizer:textMessageTap];
    self.textLabel.userInteractionEnabled = YES;
    [self.bubbleBackgroundView addGestureRecognizer:textMessageTap];
}

- (void)tapTextMessage:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    
    [self setAutoLayout];
}

- (void)setAutoLayout {
    RCChrisMessage *testMessage = (RCChrisMessage *)self.model.content;
    if (testMessage) {
        self.textLabel.text = testMessage.content;
    }
    
    CGSize textLabelSize = [[self class] getTextLabelSize:testMessage];
    CGSize bubbleBackgroundViewSize = [[self class] getBubbleSize:textLabelSize];
    CGRect messageContentViewRect = self.messageContentView.frame;
    
    //拉伸图片
    if (MessageDirection_RECEIVE == self.messageDirection) {
        self.textLabel.frame =
        CGRectMake(0,0, textLabelSize.width, textLabelSize.height);
        
        messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
        self.messageContentView.frame = messageContentViewRect;
        
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, 215, 92);
        self.bubbleBackgroundView.backgroundColor = [UIColor clearColor];
        
        self.bubbleBackgroundView.image = [UIImage imageNamed:@"wechat"];
    } else {
        self.textLabel.frame =
        CGRectMake(12, 7, textLabelSize.width, textLabelSize.height);
        
        messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
        messageContentViewRect.size.height = bubbleBackgroundViewSize.height;
        messageContentViewRect.origin.x =
        self.baseContentView.bounds.size.width -
        (messageContentViewRect.size.width + HeadAndContentSpacing +
         10 + 10);
        self.messageContentView.frame = messageContentViewRect;
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
        if([platform isEqualToString:@"iPhone5,1"]||[platform isEqualToString:@"iPhone5,2"]||[platform isEqualToString:@"iPhone8,4"]||[platform isEqualToString:@"iPhone6,2"]||[platform isEqualToString:@"iPhone6,1"]){
            self.bubbleBackgroundView.frame = CGRectMake(-75, 0, 215, 92);
        }else{
           self.bubbleBackgroundView.frame = CGRectMake(0, 0, 215, 92);
        }
        
        self.bubbleBackgroundView.backgroundColor = [UIColor clearColor];
        self.bubbleBackgroundView.image = [UIImage imageNamed:@"wechat"];
    }
}

- (void)longPressed:(id)sender {
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        [self.delegate didLongTouchMessageCell:self.model
                                        inView:self.bubbleBackgroundView];
    }
}

+ (CGSize)getTextLabelSize:(RCChrisMessage *)message {
    if ([message.content length] > 0) {
        float maxWidth =
        [UIScreen mainScreen].bounds.size.width -
        (10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10) * 2 - 5 -
        35;
        CGRect textRect = [message.content
                           boundingRectWithSize:CGSizeMake(maxWidth, 8000)
                           options:(NSStringDrawingTruncatesLastVisibleLine |
                                    NSStringDrawingUsesLineFragmentOrigin |
                                    NSStringDrawingUsesFontLeading)
                           attributes:@{
                                        NSFontAttributeName :
                                            [UIFont systemFontOfSize:Test_Message_Font_Size]
                                        }
                           context:nil];
        textRect.size.height = ceilf(textRect.size.height);
        textRect.size.width = ceilf(textRect.size.width);
        return CGSizeMake(textRect.size.width + 5, textRect.size.height + 5);
    } else {
        return CGSizeZero;
    }
}


+ (CGSize)getBubbleSize:(CGSize)textLabelSize {
    CGSize bubbleSize = CGSizeMake(textLabelSize.width, textLabelSize.height);
    
    if (bubbleSize.width + 12 + 20 > 50) {
        bubbleSize.width = bubbleSize.width + 12 + 20;
    } else {
        bubbleSize.width = 50;
    }
    if (bubbleSize.height + 7 + 7 > 40) {
        bubbleSize.height = bubbleSize.height + 7 + 7;
    } else {
        bubbleSize.height = 40;
    }
    
    return bubbleSize;
}

+ (CGSize)getBubbleBackgroundViewSize:(RCChrisMessage *)message {
    CGSize textLabelSize = [[self class] getTextLabelSize:message];
    return [[self class] getBubbleSize:textLabelSize];
}
@end

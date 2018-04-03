//
//  RCDRegisterViewController.m
//  RCloudMessage
//
//  Created by Liv on 15/3/10.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDRegisterViewController.h"
#import "AFHttpTool.h"
#import "MBProgressHUD.h"
#import "RCAnimatedImagesView.h"
#import "RCDCommonDefine.h"
#import "RCDFindPswViewController.h"
#import "RCDLoginViewController.h"
#import "RCDTextFieldValidate.h"
#import "RCUnderlineTextField.h"
#import <RongIMLib/RongIMLib.h>
#import "UIColor+RCColor.h"
#import "PsdViewController.h"
#import "AppInfoViewController.h"
@interface RCDRegisterViewController () <UITextFieldDelegate>
@property(unsafe_unretained, nonatomic) IBOutlet UITextField *tfEmail;
@property(unsafe_unretained, nonatomic) IBOutlet UITextField *tfNickName;
@property(unsafe_unretained, nonatomic) IBOutlet UITextField *tfPassword;
@property(unsafe_unretained, nonatomic) IBOutlet UITextField *tfRePassword;
@property(nonatomic, strong) UIView *headBackground;
@property(nonatomic, strong) UIImageView *rongLogo;
@property(nonatomic, strong) UIView *inputBackground;
@property(weak, nonatomic) IBOutlet UITextField *tfMobile;
@property(retain, nonatomic) IBOutlet RCAnimatedImagesView *animatedImagesView;
@property(nonatomic, strong) UIView *statusBarView;
@property(nonatomic, strong) UILabel *licenseLb;
@property(nonatomic, strong) UILabel *errorMsgLb;
@property(strong, nonatomic) IBOutlet UILabel *countDownLable;
@property(strong, nonatomic) IBOutlet UIButton *getVerificationCodeBt;
@property (nonatomic,strong) UIButton *checkbox;
@end

@implementation RCDRegisterViewController {
  NSTimer *_CountDownTimer;
  int _Seconds;
  NSString *_PhoneNumber;
  MBProgressHUD *hud;
}
#define UserTextFieldTag 1000
#define PassWordFieldTag 1001
#define RePassWordFieldTag 1002
#define NickNameFieldTag 1003
#define VerificationCodeFieldTag 1004
#define RecommendTextFieldTag 1005
//@synthesize animatedImagesView = _animatedImagesView;
@synthesize inputBackground = _inputBackground;
- (void)viewDidLoad {
  [super viewDidLoad];
  [self.navigationController setNavigationBarHidden:YES animated:YES];
//  self.animatedImagesView = [[RCAnimatedImagesView alloc]
//      initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,
//                               self.view.bounds.size.height)];
//  [self.view addSubview:self.animatedImagesView];
    UIView *backgroudView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    backgroudView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroudView];
  self.animatedImagesView.delegate = self;

  _headBackground = [[UIView alloc]
      initWithFrame:CGRectMake(0, -100, self.view.bounds.size.width, 50)];
  _headBackground.userInteractionEnabled = YES;
//  _headBackground.backgroundColor =
//      [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.2];
    _headBackground.backgroundColor = [UIColor blackColor];
  [self.view addSubview:_headBackground];

  UIButton *registerHeadButton = [[UIButton alloc]
      initWithFrame:CGRectMake(self.view.bounds.size.width - 80, 0, 70, 50)];
  [registerHeadButton setTitle:NSLocalizedStringFromTable(@"Sign in", @"RongCloudKit",nil) forState:UIControlStateNormal];
  [registerHeadButton setTitleColor:[[UIColor alloc] initWithRed:153
                                                           green:153
                                                            blue:153
                                                           alpha:0.5]
                           forState:UIControlStateNormal];
  [registerHeadButton.titleLabel
      setFont:[UIFont fontWithName:@"Heiti SC" size:14.0]];
  [registerHeadButton addTarget:self
                         action:@selector(loginPageEvent)
               forControlEvents:UIControlEventTouchUpInside];

  [_headBackground addSubview:registerHeadButton];
  UIImage *rongLogoSmallImage = [UIImage imageNamed:@"title_logo_small"];

  UIImageView *rongLogoSmallImageView = [[UIImageView alloc]
      initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 60, 5, 100,
                               40)];
  [rongLogoSmallImageView setImage:rongLogoSmallImage];

  [rongLogoSmallImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
  rongLogoSmallImageView.contentMode = UIViewContentModeScaleAspectFit;
  rongLogoSmallImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
  rongLogoSmallImageView.clipsToBounds = YES;
  [_headBackground addSubview:rongLogoSmallImageView];
  UIButton *forgetPswHeadButton =
      [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];

  [forgetPswHeadButton setTitle:NSLocalizedStringFromTable(@"Forget Password", @"RongCloudKit",nil) forState:UIControlStateNormal];
  [forgetPswHeadButton setTitleColor:[[UIColor alloc] initWithRed:153
                                                            green:153
                                                             blue:153
                                                            alpha:0.5]
                            forState:UIControlStateNormal];
    
  [forgetPswHeadButton.titleLabel
      setFont:[UIFont fontWithName:@"Heiti SC" size:14.0]];
  [forgetPswHeadButton addTarget:self
                          action:@selector(forgetPswEvent)
                forControlEvents:UIControlEventTouchUpInside];
  [_headBackground addSubview:forgetPswHeadButton];
  _licenseLb = [[UILabel alloc] initWithFrame:CGRectZero];
  //  _licenseLb.text = @"仅供演示融云 SDK 功能使用";
  _licenseLb.font = [UIFont fontWithName:@"Heiti SC" size:12.0];
  _licenseLb.translatesAutoresizingMaskIntoConstraints = NO;
  _licenseLb.textColor =
      [[UIColor alloc] initWithRed:153 green:153 blue:153 alpha:0.5];
  [self.view addSubview:_licenseLb];
    NSString *imgName = nil;
    if([[self getPreferredLanguage] isEqualToString:@"zh"]){
        imgName = @"login_logo";
    }else{
        imgName = @"login_logo_en";
    }
  UIImage *rongLogoImage = [UIImage imageNamed:imgName];
  _rongLogo = [[UIImageView alloc] initWithImage:rongLogoImage];
  _rongLogo.contentMode = UIViewContentModeScaleAspectFit;
  _rongLogo.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_rongLogo];

  _inputBackground = [[UIView alloc] initWithFrame:CGRectZero];
  _inputBackground.translatesAutoresizingMaskIntoConstraints = NO;
  _inputBackground.userInteractionEnabled = YES;
  [self.view addSubview:_inputBackground];
  _errorMsgLb = [[UILabel alloc] initWithFrame:CGRectZero];
  _errorMsgLb.text = @"";
  _errorMsgLb.font = [UIFont fontWithName:@"Heiti SC" size:12.0];
  _errorMsgLb.translatesAutoresizingMaskIntoConstraints = NO;
  _errorMsgLb.textColor = [UIColor colorWithRed:204.0f / 255.0f
                                          green:51.0f / 255.0f
                                           blue:51.0f / 255.0f
                                          alpha:1];
  [self.view addSubview:_errorMsgLb];
  RCUnderlineTextField *userNameTextField =
      [[RCUnderlineTextField alloc] initWithFrame:CGRectZero];

  userNameTextField.backgroundColor = [UIColor clearColor];
  userNameTextField.tag = UserTextFieldTag;
  //_account.placeholder=[NSString stringWithFormat:@"Email"];
  UIColor *color = [UIColor blackColor];
  userNameTextField.attributedPlaceholder = [[NSAttributedString alloc]
      initWithString:NSLocalizedStringFromTable(@"Phone Number", @"RongCloudKit",nil)
          attributes:@{NSForegroundColorAttributeName : color}];
  userNameTextField.textColor = [UIColor blackColor];
  self.view.translatesAutoresizingMaskIntoConstraints = YES;
  userNameTextField.translatesAutoresizingMaskIntoConstraints = NO;
  userNameTextField.adjustsFontSizeToFitWidth = YES;
  userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  [_inputBackground addSubview:userNameTextField];
  userNameTextField.keyboardType = UIKeyboardTypeNumberPad;
  if (userNameTextField.text.length > 0) {
    [userNameTextField setFont:[UIFont fontWithName:@"Heiti SC" size:25.0]];
  }

  [userNameTextField addTarget:self
                        action:@selector(textFieldDidChange:)
              forControlEvents:UIControlEventEditingChanged];
  UILabel *userNameMsgLb = [[UILabel alloc] initWithFrame:CGRectZero];
  userNameMsgLb.text = NSLocalizedStringFromTable(@"Phone Number", @"RongCloudKit",nil);

  userNameMsgLb.font = [UIFont fontWithName:@"Heiti SC" size:10.0];
  userNameMsgLb.translatesAutoresizingMaskIntoConstraints = NO;
//  userNameMsgLb.textColor =
//      [[UIColor alloc] initWithRed:153 green:153 blue:153 alpha:0.5];
    userNameMsgLb.textColor = [UIColor blackColor];
  [_inputBackground addSubview:userNameMsgLb];
  _PhoneNumber = userNameTextField.text;
  userNameTextField.delegate = self;

//  RCUnderlineTextField *verificationCodeField =
//      [[RCUnderlineTextField alloc] initWithFrame:CGRectZero];
//
//  verificationCodeField.backgroundColor = [UIColor clearColor];
//  verificationCodeField.tag = VerificationCodeFieldTag;
//  verificationCodeField.attributedPlaceholder = [[NSAttributedString alloc]
//      initWithString:NSLocalizedStringFromTable(@"Verification Code", @"RongCloudKit",nil)
//          attributes:@{NSForegroundColorAttributeName : color}];
//  verificationCodeField.textColor = [UIColor blackColor];
//  self.view.translatesAutoresizingMaskIntoConstraints = YES;
//  verificationCodeField.translatesAutoresizingMaskIntoConstraints = NO;
//  verificationCodeField.adjustsFontSizeToFitWidth = YES;
//  verificationCodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
//  verificationCodeField.keyboardType = UIKeyboardTypeNumberPad;
//  [_inputBackground addSubview:verificationCodeField];
//  if (verificationCodeField.text.length > 0) {
//    [verificationCodeField setFont:[UIFont fontWithName:@"Heiti SC" size:25.0]];
//  }
//
//  [verificationCodeField addTarget:self
//                            action:@selector(textFieldDidChange:)
//                  forControlEvents:UIControlEventEditingChanged];
//  UILabel *verificationCodeLb = [[UILabel alloc] initWithFrame:CGRectZero];
//  verificationCodeLb.text = NSLocalizedStringFromTable(@"Verification Code", @"RongCloudKit",nil);
//  verificationCodeLb.hidden = YES;
//
//  verificationCodeLb.font = [UIFont fontWithName:@"Heiti SC" size:10.0];
//  verificationCodeLb.translatesAutoresizingMaskIntoConstraints = NO;
//  verificationCodeLb.textColor = [UIColor blackColor];
//  [_inputBackground addSubview:verificationCodeLb];
//  verificationCodeField.delegate = self;
//
//  _getVerificationCodeBt = [[UIButton alloc] init];
//  [_getVerificationCodeBt
//      setBackgroundColor:[[UIColor alloc] initWithRed:133 / 255.f
//                                                green:133 / 255.f
//                                                 blue:133 / 255.f
//                                                alpha:1]];
//  [_getVerificationCodeBt setTitle:NSLocalizedStringFromTable(@"Send Code", @"RongCloudKit",nil) forState:UIControlStateNormal];
//  [_getVerificationCodeBt setTitleColor:[UIColor blackColor]
//                               forState:UIControlStateNormal];
//  [_getVerificationCodeBt addTarget:self
//                             action:@selector(getVerficationCode)
//                   forControlEvents:UIControlEventTouchUpInside];
//  _getVerificationCodeBt.translatesAutoresizingMaskIntoConstraints = NO;
//  [_getVerificationCodeBt.titleLabel
//      setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
//  _getVerificationCodeBt.enabled = NO;
//  _getVerificationCodeBt.layer.masksToBounds = YES;
//  _getVerificationCodeBt.layer.cornerRadius = 6.f;
//  [_inputBackground addSubview:_getVerificationCodeBt];

//  _countDownLable = [[UILabel alloc] init];
//  _countDownLable.textColor = [UIColor blackColor];
//  [_countDownLable setBackgroundColor:[[UIColor alloc] initWithRed:133 / 255.f
//                                                             green:133 / 255.f
//                                                              blue:133 / 255.f
//                                                             alpha:1]];
//  _countDownLable.textAlignment = UITextAlignmentCenter;
//  [_countDownLable setFont:[UIFont fontWithName:@"Heiti SC" size:13.0]];
//  _countDownLable.text = @"60";
//  _countDownLable.translatesAutoresizingMaskIntoConstraints = NO;
//  _countDownLable.hidden = YES;
//  _countDownLable.layer.masksToBounds = YES;
//  _countDownLable.layer.cornerRadius = 6.f;
//  [_inputBackground addSubview:_countDownLable];

  RCUnderlineTextField *passwordTextField =
      [[RCUnderlineTextField alloc] initWithFrame:CGRectZero];
  passwordTextField.tag = PassWordFieldTag;
  passwordTextField.textColor = [UIColor blackColor];
  passwordTextField.returnKeyType = UIReturnKeyDone;
  passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  passwordTextField.secureTextEntry = YES;
  passwordTextField.delegate = self;
  passwordTextField.attributedPlaceholder = [[NSAttributedString alloc]
      initWithString:NSLocalizedStringFromTable(@"Password", @"RongCloudKit",nil)
          attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
  passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
  // passwordTextField.text = [self getDefaultUserPwd];
  [_inputBackground addSubview:passwordTextField];
  UILabel *pswMsgLb = [[UILabel alloc] initWithFrame:CGRectZero];
  pswMsgLb.text = NSLocalizedStringFromTable(@"6-16Characters Case sensitive", @"RongCloudKit",nil);
  pswMsgLb.font = [UIFont fontWithName:@"Heiti SC" size:10.0];
  pswMsgLb.translatesAutoresizingMaskIntoConstraints = NO;
//  pswMsgLb.textColor =
//      [[UIColor alloc] initWithRed:153 green:153 blue:153 alpha:0.5];
    pswMsgLb.textColor = [UIColor blackColor];
  [_inputBackground addSubview:pswMsgLb];

  RCUnderlineTextField *rePasswordTextField =
      [[RCUnderlineTextField alloc] initWithFrame:CGRectZero];
  rePasswordTextField.tag = RePassWordFieldTag;
  rePasswordTextField.delegate = self;
  rePasswordTextField.textColor = [UIColor blackColor];
  rePasswordTextField.returnKeyType = UIReturnKeyDone;
  // rePasswordTextField.secureTextEntry = YES;
  // passwordTextField.delegate = self;
  rePasswordTextField.adjustsFontSizeToFitWidth = YES;
  rePasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  rePasswordTextField.attributedPlaceholder = [[NSAttributedString alloc]
      initWithString:NSLocalizedStringFromTable(@"Nickname", @"RongCloudKit",nil)
          attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
  rePasswordTextField.translatesAutoresizingMaskIntoConstraints = NO;
  // passwordTextField.text = [self getDefaultUserPwd];
  [rePasswordTextField addTarget:self
                          action:@selector(textFieldDidChange:)
                forControlEvents:UIControlEventEditingChanged];
  [_inputBackground addSubview:rePasswordTextField];
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, rePasswordTextField.frame.origin.y-1,rePasswordTextField.frame.size.width, 5)];
//    line.backgroundColor = [UIColor blackColor];
//    [_inputBackground addSubview:line];
    
  if (rePasswordTextField.text.length > 0) {
    [rePasswordTextField setFont:[UIFont fontWithName:@"Heiti SC" size:25.0]];
  }

    //Chris：增加推荐人
    RCUnderlineTextField *recommendTextField =
    [[RCUnderlineTextField alloc] initWithFrame:CGRectZero];
    recommendTextField.tag = RecommendTextFieldTag;
    recommendTextField.delegate = self;
    recommendTextField.textColor = [UIColor blackColor];
    recommendTextField.returnKeyType = UIReturnKeyDone;
    recommendTextField.adjustsFontSizeToFitWidth = YES;
    recommendTextField.keyboardType = UIKeyboardTypeNumberPad;
    recommendTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    recommendTextField.attributedPlaceholder = [[NSAttributedString alloc]
                                                 initWithString:NSLocalizedStringFromTable(@"Recommender ID(optional)", @"RongCloudKit",nil)
                                                 attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    recommendTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [recommendTextField addTarget:self
                            action:@selector(textFieldDidChange:)
                  forControlEvents:UIControlEventEditingChanged];
    //recommendTextField.font = [UIFont fontWithName:@"Heiti SC" size:25.0];
    if (recommendTextField.text.length > 0) {
        [recommendTextField setFont:[UIFont fontWithName:@"Heiti SC" size:25.0]];
    }
    [_inputBackground addSubview:recommendTextField];
    
  // UIEdgeInsets buttonEdgeInsets = UIEdgeInsetsMake(0, 7.f, 0, 7.f);
  UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [loginButton addTarget:self
                  action:@selector(btnDoneClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    NSString *btnImgName = nil;
    if([[self getPreferredLanguage] isEqualToString:@"zh"]){
        btnImgName = @"register_button";
    }else{
        btnImgName = @"register_button_en";
    }
  [loginButton setBackgroundImage:[UIImage imageNamed:btnImgName]
                         forState:UIControlStateNormal];
  loginButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
  loginButton.translatesAutoresizingMaskIntoConstraints = NO;
  [_inputBackground addSubview:loginButton];

  UIButton *userProtocolButton = [[UIButton alloc] initWithFrame:CGRectZero];
  //  [userProtocolButton setTitle:@"阅读用户协议"
  //  forState:UIControlStateNormal];
  [userProtocolButton setTitleColor:[[UIColor alloc] initWithRed:153
                                                           green:153
                                                            blue:153
                                                           alpha:0.5]
                           forState:UIControlStateNormal];
  userProtocolButton.titleLabel.font = [UIFont systemFontOfSize:14];
  [userProtocolButton addTarget:self
                         action:@selector(userProtocolEvent)
               forControlEvents:UIControlEventTouchUpInside];

  userProtocolButton.translatesAutoresizingMaskIntoConstraints = NO;

  [self.view addSubview:userProtocolButton];

  UIView *bottomBackground = [[UIView alloc] initWithFrame:CGRectZero];
  bottomBackground.translatesAutoresizingMaskIntoConstraints = NO;
  UIButton *registerButton = [[UIButton alloc]
      initWithFrame:CGRectMake(self.view.bounds.size.width - 100, -16, 80, 50)];
  [registerButton setTitle:NSLocalizedStringFromTable(@"Sign in", @"RongCloudKit",nil) forState:UIControlStateNormal];
//  [registerButton setTitleColor:[[UIColor alloc] initWithRed:153
//                                                       green:153
//                                                        blue:153
//                                                       alpha:0.5]
//                       forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
  [registerButton.titleLabel
      setFont:[UIFont fontWithName:@"Heiti SC" size:14.0]];
  [registerButton addTarget:self
                     action:@selector(loginPageEvent)
           forControlEvents:UIControlEventTouchUpInside];

  [bottomBackground addSubview:registerButton];

  UIButton *forgetPswButton =
      [[UIButton alloc] initWithFrame:CGRectMake(-10, -16, 80, 50)];
  [forgetPswButton setTitle:NSLocalizedStringFromTable(@"Forgot Password", @"RongCloudKit",nil) forState:UIControlStateNormal];
//  [forgetPswButton setTitleColor:[[UIColor alloc] initWithRed:153
//                                                        green:153
//                                                         blue:153
//                                                        alpha:0.5]
//                        forState:UIControlStateNormal];
    [forgetPswButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
  forgetPswButton.titleLabel.font = [UIFont systemFontOfSize:18];
  [forgetPswButton.titleLabel
      setFont:[UIFont fontWithName:@"Heiti SC" size:14.0]];
  [forgetPswButton addTarget:self
                      action:@selector(forgetPswEvent)
            forControlEvents:UIControlEventTouchUpInside];
  [bottomBackground addSubview:forgetPswButton];
  
  CGRect screenBounds = self.view.frame;
//  UILabel *footerLabel = [[UILabel alloc] init];
//  footerLabel.textAlignment = NSTextAlignmentCenter;
//  footerLabel.frame = CGRectMake(screenBounds.size.width / 2 - 100, -2, 200, 21);
//  footerLabel.text = @"Powered by RongCloud";
//  [footerLabel setFont:[UIFont systemFontOfSize:12.f]];
//  [footerLabel setTextColor:[UIColor colorWithHexString:@"484848" alpha:1.0]];
//  [bottomBackground addSubview:footerLabel];

  [self.view addSubview:bottomBackground];
    UIView *blankView = [[UIView alloc]initWithFrame:CGRectZero];
    blankView.contentMode = UIViewContentModeScaleAspectFit;
    blankView.translatesAutoresizingMaskIntoConstraints = NO;
    [_inputBackground addSubview:blankView];
    _checkbox = [[UIButton alloc]initWithFrame:CGRectZero];
    _checkbox.frame = CGRectMake(0, 0, 20, 20);
    [_checkbox setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    [_checkbox setImage:[UIImage imageNamed:@"checkbox2"] forState:UIControlStateSelected];
    [_checkbox addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    [blankView addSubview:_checkbox];
    UILabel *appInfoLbl = [[UILabel alloc]initWithFrame:CGRectMake(22, 0, 250, 20)];
    if([[self getPreferredLanguage] isEqualToString:@"zh"]){
        appInfoLbl.text = @"1问1答MoneyCall软件许可及服务协议";
    }else{
        appInfoLbl.text = @"MoneyCall Licensing and Protocol";
    }
    
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick)];
    [appInfoLbl addGestureRecognizer:labelTapGestureRecognizer];
    appInfoLbl.userInteractionEnabled = YES;
//    appInfoLbl.adjustsFontSizeToFitWidth = YES;
    appInfoLbl.font = [UIFont fontWithName:@"Heiti SC" size:14.0];
    [appInfoLbl setTextColor:[UIColor grayColor]];
    [blankView addSubview:appInfoLbl];

//  [self.view addConstraint:[NSLayoutConstraint
//                               constraintWithItem:userNameMsgLb
//                                        attribute:NSLayoutAttributeBottom
//                                        relatedBy:NSLayoutRelationEqual
//                                           toItem:userNameTextField
//                                        attribute:NSLayoutAttributeBottom
//                                       multiplier:1.0
//                                         constant:0]];
//  [self.view addConstraint:[NSLayoutConstraint
//                               constraintWithItem:userNameMsgLb
//                                        attribute:NSLayoutAttributeRight
//                                        relatedBy:NSLayoutRelationEqual
//                                           toItem:userNameTextField
//                                        attribute:NSLayoutAttributeRight
//                                       multiplier:1.0
//                                         constant:-7]];
//  [self.view addConstraint:[NSLayoutConstraint
//                               constraintWithItem:verificationCodeLb
//                                        attribute:NSLayoutAttributeBottom
//                                        relatedBy:NSLayoutRelationEqual
//                                           toItem:verificationCodeField
//                                        attribute:NSLayoutAttributeBottom
//                                       multiplier:1.0
//                                         constant:0]];
//  [self.view addConstraint:[NSLayoutConstraint
//                               constraintWithItem:verificationCodeLb
//                                        attribute:NSLayoutAttributeRight
//                                        relatedBy:NSLayoutRelationEqual
//                                           toItem:verificationCodeField
//                                        attribute:NSLayoutAttributeRight
//                                       multiplier:1.0
//                                         constant:-7]];
//  [self.view addConstraint:[NSLayoutConstraint
//                               constraintWithItem:_getVerificationCodeBt
//                                        attribute:NSLayoutAttributeBottom
//                                        relatedBy:NSLayoutRelationEqual
//                                           toItem:verificationCodeField
//                                        attribute:NSLayoutAttributeBottom
//                                       multiplier:1.0
//                                         constant:-15]];
//  [self.view addConstraint:[NSLayoutConstraint
//                               constraintWithItem:_countDownLable
//                                        attribute:NSLayoutAttributeBottom
//                                        relatedBy:NSLayoutRelationEqual
//                                           toItem:verificationCodeField
//                                        attribute:NSLayoutAttributeBottom
//                                       multiplier:1.0
//                                         constant:-17]];
//  [self.view addConstraint:[NSLayoutConstraint
//                               constraintWithItem:_countDownLable
//                                        attribute:NSLayoutAttributeRight
//                                        relatedBy:NSLayoutRelationEqual
//                                           toItem:_getVerificationCodeBt
//                                        attribute:NSLayoutAttributeRight
//                                       multiplier:1.0
//                                         constant:0]];
//  [self.view addConstraint:[NSLayoutConstraint
//                               constraintWithItem:_countDownLable
//                                        attribute:NSLayoutAttributeHeight
//                                        relatedBy:NSLayoutRelationEqual
//                                           toItem:_getVerificationCodeBt
//                                        attribute:NSLayoutAttributeHeight
//                                       multiplier:1.0
//                                         constant:0]];
//  [self.view addConstraint:[NSLayoutConstraint
//                               constraintWithItem:_countDownLable
//                                        attribute:NSLayoutAttributeWidth
//                                        relatedBy:NSLayoutRelationEqual
//                                           toItem:_getVerificationCodeBt
//                                        attribute:NSLayoutAttributeWidth
//                                       multiplier:1.0
//                                         constant:0]];
//  [self.view addConstraint:[NSLayoutConstraint
//                               constraintWithItem:pswMsgLb
//                                        attribute:NSLayoutAttributeBottom
//                                        relatedBy:NSLayoutRelationEqual
//                                           toItem:passwordTextField
//                                        attribute:NSLayoutAttributeBottom
//                                       multiplier:1.0
//                                         constant:0]];
//  [self.view addConstraint:[NSLayoutConstraint
//                               constraintWithItem:pswMsgLb
//                                        attribute:NSLayoutAttributeRight
//                                        relatedBy:NSLayoutRelationEqual
//                                           toItem:passwordTextField
//                                        attribute:NSLayoutAttributeRight
//                                       multiplier:1.0
//                                         constant:-7]];
//
  [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:bottomBackground
                                        attribute:NSLayoutAttributeBottom
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self.view
                                        attribute:NSLayoutAttributeBottom
                                       multiplier:1.0
                                         constant:20]];

  [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:_rongLogo
                                        attribute:NSLayoutAttributeCenterX
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self.view
                                        attribute:NSLayoutAttributeCenterX
                                       multiplier:1.0
                                         constant:0]];

  NSDictionary *views = NSDictionaryOfVariableBindings(
      _errorMsgLb, _licenseLb, _rongLogo, _inputBackground, userProtocolButton,
      bottomBackground);

  NSArray *viewConstraints = [[[[[[[[NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|-41-[_inputBackground]-41-|"
                          options:0
                          metrics:nil
                            views:views]
            arrayByAddingObjectsFromArray:
                [NSLayoutConstraint
                    constraintsWithVisualFormat:@"H:|[_rongLogo]|"
                                        options:0
                                        metrics:nil
                                          views:views]]
      arrayByAddingObjectsFromArray:
          [NSLayoutConstraint constraintsWithVisualFormat:
                                  @"V:|-70-[_rongLogo(100)]-10-[_errorMsgLb(=="
                                  @"12)]-1-[_inputBackground(==400)]-"
                                  @"80-[userProtocolButton(==20)]"
                                                  options:0
                                                  metrics:nil
                                                    views:views]]

      arrayByAddingObjectsFromArray:
          [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_rongLogo(100)]"
                                                  options:0
                                                  metrics:nil
                                                    views:views]]

      arrayByAddingObjectsFromArray:
          [NSLayoutConstraint
              constraintsWithVisualFormat:@"V:[bottomBackground(==50)]"
                                  options:0
                                  metrics:nil
                                    views:views]]
      arrayByAddingObjectsFromArray:
          [NSLayoutConstraint
              constraintsWithVisualFormat:@"H:|-10-[bottomBackground]-10-|"
                                  options:0
                                  metrics:nil
                                    views:views]]
      arrayByAddingObjectsFromArray:
          [NSLayoutConstraint
              constraintsWithVisualFormat:@"H:|-40-[_licenseLb]-10-|"
                                  options:0
                                  metrics:nil
                                    views:views]]
      arrayByAddingObjectsFromArray:
          [NSLayoutConstraint
              constraintsWithVisualFormat:@"H:|-40-[_errorMsgLb]-10-|"
                                  options:0
                                  metrics:nil
                                    views:views]];

  [self.view addConstraints:viewConstraints];

  NSLayoutConstraint *userProtocolLabelConstraint =
      [NSLayoutConstraint constraintWithItem:userProtocolButton
                                   attribute:NSLayoutAttributeCenterX
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self.view
                                   attribute:NSLayoutAttributeCenterX
                                  multiplier:1.f
                                    constant:0];
  [self.view addConstraint:userProtocolLabelConstraint];
  NSDictionary *inputViews = NSDictionaryOfVariableBindings(
       userNameTextField,rePasswordTextField,passwordTextField,
       recommendTextField,blankView,
      loginButton);

  NSArray *inputViewConstraints = [[[[[[
      [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[userNameTextField]|"
                                              options:0
                                              metrics:nil
                                                views:inputViews]
      arrayByAddingObjectsFromArray:
//          [NSLayoutConstraint
//              constraintsWithVisualFormat:
//                  @"H:|[verificationCodeField][_getVerificationCodeBt]|"
//                                  options:0
//                                  metrics:nil
//                                    views:inputViews]]
//      arrayByAddingObjectsFromArray:
//          [NSLayoutConstraint
//              constraintsWithVisualFormat:@"H:[_getVerificationCodeBt(100)]|"
//                                  options:0
//                                  metrics:nil
//                                    views:inputViews]]

//                                            arrayByAddingObjectsFromArray:
//                                            [NSLayoutConstraint
//                                             constraintsWithVisualFormat:@"H:[verificationCodeField]-[_countDownLable]|"
//                                             options:0
//                                             metrics:nil
//                                             views:inputViews]]
//      arrayByAddingObjectsFromArray:
          [NSLayoutConstraint
              constraintsWithVisualFormat:@"H:|[passwordTextField]|"
                                  options:0
                                  metrics:nil
                                    views:inputViews]]
      arrayByAddingObjectsFromArray:
          [NSLayoutConstraint
              constraintsWithVisualFormat:@"H:|[rePasswordTextField]|"
                                   options:0
                                   metrics:nil
                                   views:inputViews]]
      
      arrayByAddingObjectsFromArray:
          [NSLayoutConstraint
              constraintsWithVisualFormat:@"V:|["
                                        @"rePasswordTextField(50)]-["
                                        @"userNameTextField(50)]-["
                                        @"passwordTextField(60)]-["
                                            @"recommendTextField(60)]-["
                                            @"blankView(20)]-["
                                            @"loginButton(50)]"
                                  options:0
                                  metrics:nil
                                    views:inputViews]]

      arrayByAddingObjectsFromArray:
//          [NSLayoutConstraint
//              constraintsWithVisualFormat:@"V:[_getVerificationCodeBt(35)]"
//                                  options:0
//                                  metrics:nil
//                                    views:inputViews]]
//      arrayByAddingObjectsFromArray:
          [NSLayoutConstraint
              constraintsWithVisualFormat:@"H:|[recommendTextField]|"
                                options:0
                                metrics:nil
                                views:inputViews]]
       arrayByAddingObjectsFromArray:
       [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[blankView]|"
                                               options:0
                                               metrics:nil
                                                 views:inputViews]]
      arrayByAddingObjectsFromArray:
          [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[loginButton]|"
                                                  options:0
                                                  metrics:nil
                                                    views:inputViews]];

  [_inputBackground addConstraints:inputViewConstraints];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(keyboardWillShow:)
             name:UIKeyboardWillShowNotification
           object:self.view.window];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(keyboardWillHide:)
             name:UIKeyboardWillHideNotification
           object:self.view.window];
  _statusBarView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
//  _statusBarView.backgroundColor =
//      [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.2];
    _statusBarView.backgroundColor =
         [UIColor blackColor];
  [self.view addSubview:_statusBarView];
  [self.view setNeedsLayout];
  [self.view setNeedsUpdateConstraints];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  NSLog(@"textFieldShouldReturn");
  [textField resignFirstResponder];
  return YES;
}
- (void)textFieldDidChange:(UITextField *)textField {
  if (textField.tag == UserTextFieldTag) {
    if (textField.text.length > 0) {
      _getVerificationCodeBt.enabled = YES;
      [_getVerificationCodeBt
          setBackgroundColor:[[UIColor alloc] initWithRed:23 / 255.f
                                                    green:136 / 255.f
                                                     blue:213 / 255.f
                                                    alpha:1]];
    }
    if (textField.text.length == 0) {
      _getVerificationCodeBt.enabled = NO;
      [_getVerificationCodeBt
          setBackgroundColor:[[UIColor alloc] initWithRed:133 / 255.f
                                                    green:133 / 255.f
                                                     blue:133 / 255.f
                                                    alpha:1]];
    }
  }

  if (textField.text.length == 0) {
    [textField setFont:[UIFont fontWithName:@"Heiti SC" size:18.0]];
  } else {
    if (textField.tag == UserTextFieldTag) {
      _PhoneNumber = textField.text;
    }
    [textField setFont:[UIFont fontWithName:@"Heiti SC" size:25.0]];
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)notif {

  [UIView animateWithDuration:0.25
                   animations:^{

                     self.view.frame =
                         CGRectMake(0.f, -150, self.view.frame.size.width,
                                    self.view.frame.size.height);
                     _headBackground.frame =
                         CGRectMake(0, 70, self.view.bounds.size.width, 50);
                     _rongLogo.hidden = YES;
                     _licenseLb.hidden = YES;
                     _statusBarView.frame =
                         CGRectMake(0.f, 50, self.view.frame.size.width, 20);
                   }
                   completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notif {
  [UIView animateWithDuration:0.25
                   animations:^{
                     self.view.frame =
                         CGRectMake(0.f, 0.f, self.view.frame.size.width,
                                    self.view.frame.size.height);
                     CGRectMake(0, -100, self.view.bounds.size.width, 50);
                     _headBackground.frame =
                         CGRectMake(0, -100, self.view.bounds.size.width, 50);
                     _rongLogo.hidden = NO;
                     _licenseLb.hidden = NO;
                     _statusBarView.frame =
                         CGRectMake(0.f, 0, self.view.frame.size.width, 20);
                   }
                   completion:nil];
}
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.animatedImagesView startAnimating];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];

  [self.animatedImagesView stopAnimating];
}

/*阅读用户协议*/
- (void)userProtocolEvent {
}
/*注册*/
- (void)loginPageEvent {
  RCDLoginViewController *temp = [[RCDLoginViewController alloc] init];
  CATransition *transition = [CATransition animation];
  transition.type = kCATransitionPush;        //可更改为其他方式
  transition.subtype = kCATransitionFromLeft; //可更改为其他方式
  [self.navigationController.view.layer addAnimation:transition
                                              forKey:kCATransition];
  [self.navigationController pushViewController:temp animated:NO];
}

/*获取验证码*/
- (void)getVerficationCode {
  hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  hud.color = [UIColor colorWithHexString:@"343637" alpha:0.8];
  [hud show:YES];
  _errorMsgLb.text = @"";
  if (_PhoneNumber.length == 11) {
    NSString *phone = [NSString stringWithFormat:@"%@", _PhoneNumber];
    [AFHttpTool checkPhoneNumberAvailable:@"86"
        phoneNumber:phone
        success:^(id response) {
          if ([response[@"code"] intValue] == 200) {
            //                                              if ([[NSString
            //                                              stringWithFormat:@"%@",response[@"message"]]
            //                                              isEqualToString:@"Phone
            //                                              number has already
            //                                              existed."]) {
            if ([response[@"result"] integerValue] == 0) {
              [hud hide:YES];
              _errorMsgLb.text = NSLocalizedStringFromTable(@"This Phone Number has been used", @"RongCloudKit",nil);
              return;
            } else {
              [AFHttpTool getVerificationCode:@"86"
                  phoneNumber:phone
                  success:^(id response) {
                    [hud hide:YES];
                    _getVerificationCodeBt.hidden = YES;
                    _countDownLable.hidden = NO;
                    [self CountDown:60];
                    NSLog(@"Get verification code successfully");

                  }
                  failure:^(NSError *err) {
                    NSLog(@"%@", err);
                  }];
            }
          }

        }
        failure:^(NSError *err){
        }];
  } else {
    [hud hide:YES];
    _errorMsgLb.text = NSLocalizedStringFromTable(@"Invalid Phone Number", @"RongCloudKit",nil);
  }
}

/*找回密码*/
- (void)forgetPswEvent {
    if([[self getPreferredLanguage] isEqualToString:@"zh"]){
        RCDFindPswViewController *temp = [[RCDFindPswViewController alloc] init];
        [self.navigationController pushViewController:temp animated:YES];

    }else{
        UIStoryboard *meStoryboard = [UIStoryboard storyboardWithName:@"ForgetPsd" bundle:nil];
        PsdViewController *psdVC = [meStoryboard instantiateViewControllerWithIdentifier:@"psd"];
        [self.navigationController pushViewController:psdVC animated:YES];
    }

}

/**
 *  获取默认用户
 *
 *  @return 是否获取到数据
 */
- (BOOL)getDefaultUser {
  NSString *userName =
      [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
  NSString *userPwd =
      [[NSUserDefaults standardUserDefaults] objectForKey:@"userPwd"];
  return userName && userPwd;
}
/*获取用户账号*/
- (NSString *)getDefaultUserName {
  NSString *defaultUser =
      [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
  return defaultUser;
}
/*获取用户密码*/
- (NSString *)getDefaultUserPwd {
  NSString *defaultUserPwd =
      [[NSUserDefaults standardUserDefaults] objectForKey:@"userPwd"];
  return defaultUserPwd;
}

- (IBAction)btnDoneClicked:(id)sender {
  if (![self checkContent])
    return;
    if(!self.checkbox.selected){
         _errorMsgLb.text = NSLocalizedStringFromTable(@"Apply Protocol", @"RongCloudKit",nil);
        return;
    }
  RCNetworkStatus status =
      [[RCIMClient sharedRCIMClient] getCurrentNetworkStatus];

  if (RC_NotReachable == status) {
    _errorMsgLb.text = @"当前网络不可用，请检查！";
  }
  NSString *userName =
      [(UITextField *)[self.view viewWithTag:UserTextFieldTag] text];
  NSString *verificationCode =
      [(UITextField *)[self.view viewWithTag:VerificationCodeFieldTag] text];
  NSString *userPwd =
      [(UITextField *)[self.view viewWithTag:PassWordFieldTag] text];
  NSString *nickName =
      [(UITextField *)[self.view viewWithTag:RePassWordFieldTag] text];
    NSString *recommendPhone = [(UITextField *)[self.view viewWithTag:RecommendTextFieldTag] text];
    //注册用户
    [AFHttpTool registerWithNickname:nickName
                            password:userPwd
                    verficationToken:userName

                             success:^(id response) {
                                 NSDictionary *regResults = response;
                                 NSString *code = [NSString
                                                   stringWithFormat:@"%@", [regResults objectForKey:@"code"]];
                                 
                                 if (code.intValue == 200) {
                                     NSDictionary *result = [regResults objectForKey:@"result"];
                                     NSString *identy = [result objectForKey:@"phone"];
                                     [DEFAULTS setObject:identy forKey:@"ID"];
                                     NSString *urlStr = [NSString stringWithFormat:@"http://ask.vipjingjie.com/moblie/appUpdateData?new_phone=%@&phone=%@",identy,recommendPhone];
                                     NSURL *url = [NSURL URLWithString:urlStr];
                                     NSURLSession *session = [NSURLSession sharedSession];
                                     NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                         __weak typeof(&*self) weakSelf = self;
                                         //解析JSON
                                         NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                         NSString *result = [accessDict objectForKey:@"result"];
                                         if([result isEqualToString:@"1"]){
                                             
                                         }
                                     }];
                                     [dataTask resume];
                                     
                                     
                                     
                                     _errorMsgLb.text = @"注册成功";
                                     dispatch_after(
                                        dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_MSEC),
                                        dispatch_get_main_queue(), ^{
                                            RCDLoginViewController *loginView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
                                            loginView.ID = identy;
                                            [self.navigationController
                                             popViewControllerAnimated:YES];
                                        });
                                 }
                                 
                             }
                             failure:^(NSError *err) {
                                 NSLog(@"");
                                 _errorMsgLb.text = NSLocalizedStringFromTable(@"Sign up Failure", @"RongCloudKit",nil);
                                 
                             }];
}


- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

-(void)updateErrorMsg:(NSString *)text{
    _errorMsgLb.text = text;
}

/**
 *  检查输入内容
 *
 *  @return 是否合法输入
 */
- (BOOL)checkContent {
//  NSString *userName =
//      [(UITextField *)[self.view viewWithTag:UserTextFieldTag] text];
//  NSString *userPwd =
//      [(UITextField *)[self.view viewWithTag:PassWordFieldTag] text];
//  NSString *reUserPwd =
//      [(UITextField *)[self.view viewWithTag:RePassWordFieldTag] text];
//    NSString *reCommendPhone = [(UITextField *)[self.view viewWithTag:RecommendTextFieldTag] text];
//  if (userName.length == 0) {
//
//    _errorMsgLb.text = NSLocalizedStringFromTable(@"Empty Phone Number!", @"RongCloudKit",nil);
//    return NO;
//  }
//  if (userPwd.length > 20) {
//    _errorMsgLb.text = NSLocalizedStringFromTable(@"Password has to be shorter than 20 characters", @"RongCloudKit",nil);
//    return NO;
//  }
//  if (userPwd.length == 0) {
//    _errorMsgLb.text = NSLocalizedStringFromTable(@"Password can't be empty", @"RongCloudKit",nil);
//    return NO;
//  }
//  if (reUserPwd.length == 0) {
//    _errorMsgLb.text = NSLocalizedStringFromTable(@"Nickname can't be empty", @"RongCloudKit",nil);
//    return NO;
//  }
//  if (reUserPwd.length > 32) {
//    _errorMsgLb.text = NSLocalizedStringFromTable(@"Nickname has to be shorter than 32 characters", @"RongCloudKit",nil);
//    return NO;
//  }
//    if((reCommendPhone.length>0)&&(reCommendPhone.length<11)){
//        _errorMsgLb.text = NSLocalizedStringFromTable(@"Invalid length of the inviter's phone number", @"RongCloudKit",nil);
//        return NO;
//    }
//  NSRange _range = [reUserPwd rangeOfString:@" "];
//  if (_range.location != NSNotFound) {
//    _errorMsgLb.text = NSLocalizedStringFromTable(@"Nickname can't contains space", @"RongCloudKit",nil);
//    return NO;
//  }
//  return YES;
    return YES;
}

- (NSUInteger)animatedImagesNumberOfImages:
    (RCAnimatedImagesView *)animatedImagesView {
  return 2;
}

- (UIImage *)animatedImagesView:(RCAnimatedImagesView *)animatedImagesView
                   imageAtIndex:(NSUInteger)index {
  return [UIImage imageNamed:@"login_background.png"];
}

- (void)CountDown:(int)seconds {
  _Seconds = seconds;
  _CountDownTimer =
      [NSTimer scheduledTimerWithTimeInterval:1.0
                                       target:self
                                     selector:@selector(timeFireMethod)
                                     userInfo:nil
                                      repeats:YES];
}
- (void)timeFireMethod {
  _Seconds--;
  _countDownLable.text = [NSString stringWithFormat:@"%d", _Seconds];
  if (_Seconds == 0) {
    [_CountDownTimer invalidate];
    _countDownLable.hidden = YES;
    _getVerificationCodeBt.hidden = NO;
    _countDownLable.text = @"60";
  }
}
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if(textField.tag==RecommendTextFieldTag){
//        if(textField.text.length==11){
//            return YES;
//        }else{
//            return NO;
//        }
//    }
//    return YES;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSString*)getPreferredLanguage{
    
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    
    NSString* preferredLang = [languages objectAtIndex:0];
    
    if([preferredLang containsString:@"zh"]){
        return @"zh";
    }else{
        return @"en";
    }
}
-(void)checkboxClick:(UIButton *)btn{
    btn.selected = !btn.selected;
}
-(void)labelClick{
//    UIView *appInfoView = [[[NSBundle mainBundle] loadNibNamed:@"appInfo" owner:self options:nil] firstObject];
//    UIViewController *vc = [[UIViewController alloc]init];
//    vc.view = appInfoView;
//    appInfoView.frame = vc.view.frame;
//    [self.navigationController pushViewController:vc animated:YES];
//    [vc.navigationController setNavigationBarHidden:NO animated:YES];
////    vc.navigationController.navigationItem.title = @"1问1答MoneyCall软件许可及服务协议";
//    vc.tabBarItem.title = @"1问1答MoneyCall软件许可及服务协议";
    UIStoryboard *meStoryboard = [UIStoryboard storyboardWithName:@"appInfo" bundle:nil];
    
    AppInfoViewController *vc = [meStoryboard instantiateViewControllerWithIdentifier:@"appInfo"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end

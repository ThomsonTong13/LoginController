//
//  FindPwdByTelViewController.m
//  Miban
//
//  Created by Thomson on 15/8/14.
//  Copyright (c) 2015年 Kemi. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "MailFindPasswordViewController.h"

#import "FindPasswordButton.h"

@interface FindPasswordViewController ()
{
    NSString *_verificationCode;
}

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *step;
@property (weak, nonatomic) IBOutlet UIButton *mailButton;
@property (weak, nonatomic) IBOutlet UIButton *line;

@property (weak, nonatomic) IBOutlet UIView *buttonBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (nonatomic, strong) FindPasswordButton *button;

@property (nonatomic, strong) RACDisposable *disposable;
@property (nonatomic, strong) RACSignal *mobileValidSignal;

@property (nonatomic, assign) NSInteger mobileStep;
@property (nonatomic, copy) NSString *verificationCode;
@property (nonatomic, copy) NSString *mobileNumber;
@property (nonatomic, copy) NSString *password;

@end

@implementation FindPasswordViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    _mobileStep = 1;

    [self configViews];
    [self setupActionBinds];
}

- (void)dealloc
{
    
}

#pragma mark - Event Response

- (IBAction)onEmailButton:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(push:)])
    {
        [self.delegate push:self];
    }
}

- (void)onButton:(id)sender
{
    if (self.mobileStep == 1)
    {
        self.button.enabled = NO;

        _verificationCode = @"123456";
        self.mobileStep = 2;
        [self addAnimationsWithType:kCATransitionFromRight];
    }
    else if (self.mobileStep == 2)
    {
        if (self.button.status == FindPasswordButtonStatusNormal)
        {
            self.button.status = FindPasswordButtonStatusSending;

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                if ([_verificationCode isEqualToString:_verificationCode])
                {
                    self.button.status = FindPasswordButtonStatusNormal;
                    self.mobileStep = 3;
                    [self addAnimationsWithType:kCATransitionFromRight];
                }
                else
                {
                    self.button.status = FindPasswordButtonStatusError;
                    self.button.text = @"验证码错误";
                }
            });
        }
        else if (self.button.status == FindPasswordButtonStatusError)
        {
            self.textField.text = nil;
            self.button.status = FindPasswordButtonStatusNormal;
            self.button.text = @"确认验证码";
        }
    }
    else if (self.mobileStep == 3)
    {
        if (self.button.status == FindPasswordButtonStatusNormal)
        {
            self.button.status = FindPasswordButtonStatusSending;

            @weakify(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                @strongify(self);
                self.button.status = FindPasswordButtonStatusComplete;
                self.button.text = @"重置密码成功";
            });
        }
        else if (self.button.status == FindPasswordButtonStatusSending)
        {
            [_disposable dispose];
            self.button.status = FindPasswordButtonStatusNormal;
        }
        else if (self.button.status == FindPasswordButtonStatusComplete)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(loginFinished)])
            {
                [self.delegate loginFinished];
            }
        }
        else if (self.button.status == FindPasswordButtonStatusError)
        {
//            self.button.status = FindPasswordButtonStatusNormal;
        }
    }

    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - private methods

- (void)configViews
{
    [self.buttonBackgroundView addSubview:self.button];

    @weakify(self);
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {

        @strongify(self);
        make.edges.equalTo(self.buttonBackgroundView);
    }];

    self.view.backgroundColor = [UIColor clearColor];
}

- (void)setupActionBinds
{
    RACChannelTo(self.mailButton, highlighted) = RACChannelTo(self.line, highlighted);

    @weakify(self);
    [self.textField.rac_textSignal
     subscribeNext:^(id x) {

         @strongify(self);

         if (self.mobileStep == 1)
         {
             self.mobileNumber = x;
         }
         else if (self.mobileStep == 2)
         {
             self.verificationCode = x;

             if (self.button.status == FindPasswordButtonStatusError)
             {
                 self.button.status = FindPasswordButtonStatusNormal;
                 self.button.text = @"确认验证码";
             }
         }
         else
         {
             self.password = x;
         }
     }];

    self.popCommand = [[RACCommand alloc]
                        initWithSignalBlock:^RACSignal *(id input) {

                            @strongify(self);

                            self.button.status = FindPasswordButtonStatusNormal;

                            if (self.mobileStep == 1)
                            {
                                [self.delegate pop:self];
                            }
                            else if (self.mobileStep == 2)
                            {
                                self.mobileStep = 1;
                                [self addAnimationsWithType:kCATransitionFromLeft];

                                self.textField.text = self.mobileNumber;
                                self.button.enabled = YES;
                            }
                            else if (self.mobileStep == 3)
                            {
                                self.mobileStep = 2;
                                [self addAnimationsWithType:kCATransitionFromLeft];

                                self.textField.text = self.verificationCode;
                                self.button.enabled = YES;
                            }

                            return [RACSignal empty];
                        }];

    [[RACObserve(self, mobileStep)
      deliverOnMainThread]
      subscribeNext:^(NSNumber *step) {

          @strongify(self);

          self.button.status = FindPasswordButtonStatusNormal;

          switch (step.integerValue) {
              case 1:
              {
                  self.tipsLabel.text = @"如果您忘记密码，我们将会发送短信验证码给您。";
                  self.step.image = [UIImage imageNamed:@"login_find_password_step_one"];
                  self.textField.placeholder = @"输入您的手机号";
                  [self.button setText:@"获取验证码"];

                  break;
              }

              case 2:
              {
                  NSRange tailRange = NSMakeRange(self.mobileNumber.length - 4, 4);
                  NSString *tailNumber = [self.mobileNumber substringWithRange:tailRange];

                  self.tipsLabel.text = [NSString stringWithFormat:@"我们已将验证码发送至尾号 **%@ 手机中", tailNumber];
                  self.step.image = [UIImage imageNamed:@"login_find_password_step_two"];
                  self.textField.placeholder = @"输入您手机中的验证码";
                  [self.button setText:@"确认验证码"];

                  break;
              }

              case 3:
              {
                  self.tipsLabel.text = @"您可以重新设置密码了。";
                  self.step.image = [UIImage imageNamed:@"login_find_password_step_three"];
                  self.textField.placeholder = @"重置您的账户密码";
                  [self.button setText:@"重置登录密码"];

                  break;
              }
          }

          self.textField.text = nil;
      }];

    [[self mobileValidSignal]
      subscribeNext:^(NSNumber *x) {

          @strongify(self);
          self.button.enabled = x.boolValue;
      }];
}

- (void)addAnimationsWithType:(NSString *)type
{
    CATransition *transition = [CATransition animation];
    transition.duration = .3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = type;
    transition.delegate = self;

    [self.backgroundView.layer addAnimation:transition forKey:nil];
}

#pragma mark - Getters & Setters

- (FindPasswordButton *)button
{
    if (!_button)
    {
        _button = [FindPasswordButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _button;
}

- (RACSignal *)mobileValidSignal
{
    if (!_mobileValidSignal)
    {
        @weakify(self);

        _mobileValidSignal = [RACSignal
                              combineLatest:@[
                                              RACObserve(self, mobileNumber),
                                              RACObserve(self, verificationCode),
                                              RACObserve(self, password)
                                              ]
                              reduce:^id (NSString *mobile, NSString *verificationCode, NSString *password) {

                                  @strongify(self);

                                  if (self.mobileStep == 1)
                                  {
                                      return @([mobile isValidMobile]);
                                  }
                                  else if (self.mobileStep == 2)
                                  {
                                      return @(self.verificationCode.length > 0);
                                  }
                                  else
                                  {
                                      return @(self.password.length > 0);
                                  }
                              }];
    }

    return _mobileValidSignal;
}

@end

//
//  VerificationButton.m
//
//  Created by Thomson on 15/12/28.
//  Copyright © 2015年 KEMI. All rights reserved.
//

#import "VerificationButton.h"

static NSString * const default_image = @"login_verification_normal";
static NSString * const default_disable_image = @"login_verification_disable";
static NSString * const default_highlighted_image = @"login_verification_highlighted";
static NSString * const sending_disable_image = @"login_verification_sending_disable";

static NSString * const default_text = @"获取验证码";
static NSString * sending_text = @"%zi秒";

@interface VerificationButton ()

@property (nonatomic, assign, readwrite) VerificationButtonStatus status;

@property (nonatomic, strong) UILabel *fauxLabel;

@end

@implementation VerificationButton

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initialization];
    }

    return self;
}

#pragma mark - Private Methods

- (void)initialization
{
    self.status = VerificationButtonStatusNormal;

    [self configViews];
    [self setupLayoutConstraints];
    [self setupActionBinds];
}

- (void)configViews
{
    [self addSubview:self.fauxLabel];

    [self setBackgroundImage:[UIImage imageNamed:default_image]
                    forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:default_highlighted_image]
                    forState:UIControlStateHighlighted];

    [self setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [self setTitle:@"" forState:UIControlStateNormal];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setupLayoutConstraints
{
    @weakify(self);
    [self.fauxLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        @strongify(self);
        make.center.equalTo(self);
    }];
}

- (void)setupActionBinds
{
    @weakify(self);
    [[RACObserve(self, status)
      deliverOnMainThread]
      subscribeNext:^(NSNumber *status) {

          @strongify(self);

          switch (status.integerValue)
          {
              case VerificationButtonStatusNormal:
              {
                  [self setBackgroundImage:[UIImage imageNamed:default_disable_image]
                                  forState:UIControlStateDisabled];
                  self.fauxLabel.text = default_text;
                  self.enabled = YES;

                  break;
             }
             case VerificationButtonStatusSending:
             {
                 [self setBackgroundImage:[UIImage imageNamed:sending_disable_image]
                                 forState:UIControlStateDisabled];
                 self.enabled = NO;

                 break;
             }
             case VerificationButtonStatusComplete:
             {
                 self.status = VerificationButtonStatusNormal;

                 break;
             }
         }
     }];
}

#pragma mark - Getters & Setters

- (void)setSecond:(NSInteger)second
{
    _second = second;

    self.status = VerificationButtonStatusSending;
    self.fauxLabel.text = [NSString stringWithFormat:sending_text, second];

    if (second <= 0)
    {
        self.status = VerificationButtonStatusComplete;
    }
}

- (UILabel *)fauxLabel
{
    if (!_fauxLabel)
    {
        _fauxLabel = [UILabel new];
        _fauxLabel.textColor = [UIColor whiteColor];
        _fauxLabel.backgroundColor = [UIColor clearColor];
        _fauxLabel.numberOfLines = 1;
        _fauxLabel.textAlignment = NSTextAlignmentCenter;
        _fauxLabel.font = [UIFont systemFontOfSize:15.0];
    }

    return _fauxLabel;
}

@end

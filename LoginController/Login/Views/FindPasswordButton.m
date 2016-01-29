//
//  FindPasswordButton.m
//
//  Created by Thomson on 15/12/24.
//  Copyright © 2015年 KEMI. All rights reserved.
//

#import "FindPasswordButton.h"
#import <Masonry/Masonry.h>

static NSString * const normal_text = @"发送电子邮件";
static NSString * const sending_text = @"取消";
static NSString * const error_text = @"邮件发送失败";
static NSString * const complete_text = @"邮件发送成功";

static NSString * const default_normal_image = @"login_orange_normal";
static NSString * const default_disable_image = @"login_orange_disable";
static NSString * const default_highlighted_image = @"login_orange_highlighted";

static NSString * const sending_normal_image = @"login_error_normal";
static NSString * const sending_highlighted_image = @"login_error_highlighted";

static NSString * const complete_normal_image = @"login_right_normal";
static NSString * const complete_highlighted_image = @"login_right_highlighted";

static NSString * const error_normal_image = @"login_error_normal";
static NSString * const error_highlighted_image = @"login_error_highlighted";

@interface FindPasswordButton ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *fauxLabel;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UIImageView *completeImage;

@property (nonatomic, strong) MASConstraint *fauxLeftConstraint;

@end

@implementation FindPasswordButton

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
    self.status = FindPasswordButtonStatusNormal;

    [self configViews];
    [self setupLayoutConstraints];
    [self setupActionBinds];
}

- (void)configViews
{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.fauxLabel];

    self.backgroundColor = [UIColor clearColor];
    [self setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [self setTitle:@"" forState:UIControlStateNormal];
}

- (void)setupLayoutConstraints
{
    @weakify(self);
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {

        @strongify(self);
        make.top.and.bottom.equalTo(self);
        make.centerX.equalTo(self);
    }];

    [self.fauxLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        @strongify(self);
        make.right.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
        self.fauxLeftConstraint = make.left.equalTo(self.contentView);
    }];
}

- (void)setupActionBinds
{
    @weakify(self);
    [[RACObserve(self, status)
      deliverOnMainThread]
      subscribeNext:^(NSNumber *status) {

          @strongify(self);
          [self.fauxLeftConstraint deactivate];

          switch (status.integerValue)
          {
              case FindPasswordButtonStatusNormal:
              {
                  [self.indicator removeFromSuperview];
                  [self.completeImage removeFromSuperview];

                  [self setBackgroundImage:[UIImage imageNamed:default_normal_image]
                                  forState:UIControlStateNormal];
                  [self setBackgroundImage:[UIImage imageNamed:default_highlighted_image]
                                  forState:UIControlStateHighlighted];
                  [self setBackgroundImage:[UIImage imageNamed:default_disable_image]
                                  forState:UIControlStateDisabled];

                  self.fauxLabel.text = normal_text;

                  [self.fauxLabel mas_makeConstraints:^(MASConstraintMaker *make) {

                      @strongify(self);
                      self.fauxLeftConstraint = make.left.equalTo(self.contentView);
                  }];

                  break;
              }
              case FindPasswordButtonStatusSending:
              {
                  [self.completeImage removeFromSuperview];

                  [self setBackgroundImage:[UIImage imageNamed:sending_normal_image]
                                  forState:UIControlStateNormal];
                  [self setBackgroundImage:[UIImage imageNamed:sending_highlighted_image]
                                  forState:UIControlStateHighlighted];

                  self.fauxLabel.text = sending_text;

                  [self.contentView addSubview:self.indicator];
                  [self.indicator startAnimating];

                  [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {

                      make.left.equalTo(self.contentView);
                      make.centerY.equalTo(self.contentView);
                  }];

                  [self.fauxLabel mas_makeConstraints:^(MASConstraintMaker *make) {

                      self.fauxLeftConstraint = make.left.equalTo(self.indicator.mas_right).with.offset(16);
                  }];

                  break;
              }
              case FindPasswordButtonStatusComplete:
              {
                  [self.indicator removeFromSuperview];

                  [self setBackgroundImage:[UIImage imageNamed:complete_normal_image]
                                  forState:UIControlStateNormal];
                  [self setBackgroundImage:[UIImage imageNamed:complete_highlighted_image]
                                  forState:UIControlStateHighlighted];

                  self.fauxLabel.text = complete_text;

                  [self.contentView addSubview:self.completeImage];
                  [self.completeImage mas_makeConstraints:^(MASConstraintMaker *make) {

                      make.left.equalTo(self.contentView);
                      make.centerY.equalTo(self.contentView);
                  }];

                  [self.fauxLabel mas_makeConstraints:^(MASConstraintMaker *make) {

                      self.fauxLeftConstraint = make.left.equalTo(self.completeImage.mas_right).with.offset(16);
                  }];

                  break;
              }
              case FindPasswordButtonStatusError:
              {
                  [self.indicator removeFromSuperview];
                  [self.completeImage removeFromSuperview];

                  [self setBackgroundImage:[UIImage imageNamed:error_normal_image]
                                  forState:UIControlStateNormal];
                  [self setBackgroundImage:[UIImage imageNamed:error_highlighted_image]
                                  forState:UIControlStateHighlighted];

                  self.fauxLabel.text = error_text;

                  [self.fauxLabel mas_makeConstraints:^(MASConstraintMaker *make) {

                      self.fauxLeftConstraint = make.left.equalTo(self.contentView);
                  }];

                  break;
              }
          }
      }];
}

#pragma mark - Getters & Setters

- (void)setText:(NSString *)text
{
    _text = text;

    _fauxLabel.text = text;
    [self setNeedsUpdateConstraints];
}

- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.userInteractionEnabled = NO;
    }

    return _contentView;
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
        _fauxLabel.font = [UIFont systemFontOfSize:16.0];
    }

    return _fauxLabel;
}

- (UIActivityIndicatorView *)indicator
{
    if (!_indicator)
    {
        _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_indicator setHidesWhenStopped:YES];
    }

    return _indicator;
}

- (UIImageView *)completeImage
{
    if (!_completeImage)
    {
        _completeImage = [UIImageView new];
        _completeImage.image = [UIImage imageNamed:@"login_email_complete"];
    }

    return _completeImage;
}

@end

//
//  LoginAnimationView.m
//
//  Created by Thomson on 16/1/15.
//  Copyright © 2016年 KEMI. All rights reserved.
//

#import "LoginAnimationView.h"
#import "UIImage+LMExtension.h"
#import "UtilsMacros.h"

static CGFloat const offset = 30;

@interface LoginAnimationView ()
{
    CGFloat     _blurRadius;
    NSInteger   _index;
}

@property (nonatomic, strong) UIImageView *backgroundImageView1;
@property (nonatomic, strong) UIImageView *backgroundImageView2;
@property (nonatomic, strong) UIImageView *backgroundImageView3;

@end

@implementation LoginAnimationView

#pragma mark - Lifecycle

+ (instancetype)animation
{
    LoginAnimationView *animationView = [[LoginAnimationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];

    return animationView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self)
    {
        _index = 1;

        [self addSubview:self.backgroundImageView3];
        [self addSubview:self.backgroundImageView2];
        [self addSubview:self.backgroundImageView1];

        self.backgroundColor = [UIColor clearColor];

        [self addAnimations];
    }

    return self;
}

#pragma mark - Private Methods

- (void)addAnimations
{
    _blurRadius = .5f;

    self.backgroundImageView1.frame = CGRectMake(0, 0, self.frame.size.width + offset, self.frame.size.height);
    self.backgroundImageView2.frame = CGRectMake(0, 0, self.frame.size.width + offset, self.frame.size.height);
    self.backgroundImageView3.frame = CGRectMake(-offset, 0, self.frame.size.width + offset, self.frame.size.height);

    self.backgroundImageView1.image = [[UIImage imageNamed:@"login_background1"] blurredImageWithRadius:.5 iterations:5 tintColor:[UIColor clearColor]];
    self.backgroundImageView2.image = [[UIImage imageNamed:@"login_background2"] blurredImageWithRadius:.5 iterations:5 tintColor:[UIColor clearColor]];
    self.backgroundImageView3.image = [[UIImage imageNamed:@"login_background3"] blurredImageWithRadius:.5 iterations:5 tintColor:[UIColor clearColor]];

    @weakify(self);
    [UIView animateWithDuration:4.0
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{

                         @strongify(self);

                         switch (_index) {
                             case 1:
                             {
                                 CGRect frame = self.backgroundImageView1.frame;
                                 frame.origin.x -= 30.0;
                                 self.backgroundImageView1.frame = frame;

                                 break;
                             }

                             case 2:
                             {
                                 CGRect frame = self.backgroundImageView2.frame;
                                 frame.origin.x -= 30.0;
                                 self.backgroundImageView2.frame = frame;

                                 break;
                             }
                             case 3:
                             {
                                 CGRect frame = self.backgroundImageView3.frame;
                                 frame.origin.x += 30.0;
                                 self.backgroundImageView3.frame = frame;

                                 break;
                             }
                         }
                     }
                     completion:^(BOOL finished) {

                         @strongify(self);
                         [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateBlurRadius:) userInfo:nil repeats:YES];
                     }];
/*
    CAAnimationGroup *formGroup = [[CAAnimationGroup alloc] init];
    formGroup.duration = 5;
    formGroup.fillMode = kCAFillModeBackwards;
    formGroup.delegate = self;
    
    CABasicAnimation *flyRight = [[CABasicAnimation alloc] init];
    flyRight.keyPath = @"position.x";
    flyRight.fromValue = @(self.view.bounds.size.width/2.0);
    flyRight.toValue = @(self.view.bounds.size.width/2.0-30.0);
    
    CABasicAnimation *fadeFieldIn = [[CABasicAnimation alloc] init];
    fadeFieldIn.keyPath = @"opacity";
    fadeFieldIn.fromValue = @(0.25);
    fadeFieldIn.toValue = @(1.0);
    
    formGroup.animations = @[flyRight];
    [self.backgroundImageView.layer addAnimation:formGroup forKey:nil];

    formGroup.delegate = self;
    [formGroup setValue:@"form" forKey:@"name"];
    [formGroup setValue:_userBackgroundView.layer forKey:@"layer"];
    
    formGroup.beginTime = CACurrentMediaTime() + 0.3;
    [_userBackgroundView.layer addAnimation:formGroup forKey:nil];
    
    [formGroup setValue:_passwordBackgroundView.layer forKey:@"layer"];
    formGroup.beginTime = CACurrentMediaTime() + 0.4;
    [_passwordBackgroundView.layer addAnimation:formGroup forKey:nil];
    
    CAAnimationGroup *groupAnimation = [[CAAnimationGroup alloc] init];
    groupAnimation.beginTime = CACurrentMediaTime() + 0.5;
    groupAnimation.duration = 0.5;
    groupAnimation.fillMode = kCAFillModeBackwards;
    groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *scaleDown = [[CABasicAnimation alloc] init];
    scaleDown.keyPath = @"transform.scale";
    scaleDown.fromValue = @(3.5);
    scaleDown.toValue = @(1.0);
    
    CABasicAnimation *rotate = [[CABasicAnimation alloc] init];
    rotate.keyPath = @"transform.rotation";
    rotate.fromValue = @(M_PI_4);
    rotate.toValue = @(0.0);
    
    CABasicAnimation *fade = [[CABasicAnimation alloc] init];
    fade.keyPath = @"opacity";
    fade.fromValue = @(0.0);
    fade.toValue = @(1.0);
    
    groupAnimation.animations = @[scaleDown, rotate, fade];
    [_loginButton.layer addAnimation:groupAnimation forKey:nil];
 */
}

- (void)updateBlurRadius:(NSTimer *)timer
{
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{

        @strongify(self);
        _blurRadius += 0.3;

        switch (_index) {
            case 1:
            {
                UIImage *image = [self.backgroundImageView1.image blurredImageWithRadius:_blurRadius iterations:5 tintColor:[UIColor clearColor]];
                self.backgroundImageView1.image = image;

                break;
            }

            case 2:
            {
                UIImage *image = [self.backgroundImageView2.image blurredImageWithRadius:_blurRadius iterations:5 tintColor:[UIColor clearColor]];
                self.backgroundImageView2.image = image;

                break;
            }

            case 3:
            {
                UIImage *image = [self.backgroundImageView3.image blurredImageWithRadius:_blurRadius iterations:5 tintColor:[UIColor clearColor]];
                self.backgroundImageView3.image = image;

                break;
            }
        }

        if (_blurRadius >= 3.0)
        {
            [UIView animateWithDuration:1.0
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{

                                 switch (_index) {
                                     case 1:
                                     {
                                         self.backgroundImageView1.alpha = 0;
                                         self.backgroundImageView2.alpha = 1;
                                         break;
                                     }
                                     case 2:
                                     {
                                         self.backgroundImageView2.alpha = 0;
                                         self.backgroundImageView3.alpha = 1;
                                         break;
                                     }
                                     case 3:
                                     {
                                         self.backgroundImageView3.alpha = 0;
                                         self.backgroundImageView1.alpha = 1;
                                         break;
                                     }
                                 }
                             }
                             completion:^(BOOL finished) {

                                 [self addAnimations];
                             }];

            if (++_index > 3) _index = 1;
            [timer invalidate];
        }
    });
}

#pragma mark - Getters & Setters

- (UIImageView *)backgroundImageView1
{
    if (!_backgroundImageView1)
    {
        _backgroundImageView1 = [UIImageView new];
        _backgroundImageView1.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView1.clipsToBounds = YES;
        _backgroundImageView1.backgroundColor = [UIColor clearColor];
    }

    return _backgroundImageView1;
}

- (UIImageView *)backgroundImageView2
{
    if (!_backgroundImageView2)
    {
        _backgroundImageView2 = [UIImageView new];
        _backgroundImageView2.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView2.clipsToBounds = YES;
        _backgroundImageView2.backgroundColor = [UIColor clearColor];
        _backgroundImageView2.alpha = 0;
    }

    return _backgroundImageView2;
}

- (UIImageView *)backgroundImageView3
{
    if (!_backgroundImageView3)
    {
        _backgroundImageView3 = [UIImageView new];
        _backgroundImageView3.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView3.clipsToBounds = YES;
        _backgroundImageView3.backgroundColor = [UIColor clearColor];
        _backgroundImageView3.alpha = 0;
    }

    return _backgroundImageView3;
}

@end

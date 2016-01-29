//
//  LoginMainViewController.m
//  Miban
//
//  Created by Thomson on 15/12/23.
//  Copyright © 2015年 KEMI. All rights reserved.
//

#import "LoginMainViewController.h"
#import "LoginViewController.h"
#import "FindPasswordViewController.h"
#import "MailFindPasswordViewController.h"
#import "RegisterViewController.h"

#import "LoginAnimationView.h"

@interface LoginMainViewController () <LoginViewControllerDelegate, MobileViewControllerDelegate, MailViewControllerDelegate, RegisterViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, strong) LoginViewController *loginVc;
@property (nonatomic, strong) RegisterViewController *registerVc;
@property (nonatomic, strong) FindPasswordViewController *mobileVc;
@property (nonatomic, strong) MailFindPasswordViewController *mailVc;

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (weak, nonatomic) IBOutlet UILabel *wechatLabel;
@property (weak, nonatomic) IBOutlet UILabel *tencentLabel;
@property (weak, nonatomic) IBOutlet UILabel *sinaLabel;

@end

@implementation LoginMainViewController

#pragma mark - Lifecycle

+ (void)showLoginViewController:(UIViewController *)controller;
{
    UINavigationController *nav = (UINavigationController *)[UIViewController controllerWithStoryboardName:kLogin_Storyboard_Name storyboardIdentifier:kLogin_Nav_Storyboard_Identifier];
    LoginMainViewController *rootVc = (LoginMainViewController *)nav.topViewController;
    rootVc.source = controller;

    [controller presentViewController:nav
                             animated:YES
                           completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configViews];
    [self setupLayoutConstraints];
    [self setupActionBinds];
}

#pragma mark - Controller Delegate

- (void)pop:(id)controller
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];

    if ([controller isKindOfClass:[LoginViewController class]] ||
        [controller isKindOfClass:[RegisterViewController class]])
    {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if ([controller isKindOfClass:[FindPasswordViewController class]])
    {
        [self.scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
    }
    else if ([controller isKindOfClass:[MailFindPasswordViewController class]])
    {
        [self.scrollView setContentOffset:CGPointMake(kScreenWidth*2, 0) animated:YES];
    }
}

- (void)push:(id)controller
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];

    if ([controller isKindOfClass:[LoginViewController class]] ||
        [controller isKindOfClass:[MailFindPasswordViewController class]])
    {
        [self.scrollView setContentOffset:CGPointMake(kScreenWidth*2, 0) animated:YES];
    }
    else if ([controller isKindOfClass:[FindPasswordViewController class]])
    {
        [self.scrollView setContentOffset:CGPointMake(kScreenWidth*3, 0) animated:YES];
    }
}

- (void)loginFinished
{
    if (self.source && [self.source respondsToSelector:@selector(loginFinished)])
    {
        [self.source loginFinished];
    }

    [self.source dismissViewControllerAnimated:YES
                                    completion:nil];
}

#pragma mark - Event Response

- (IBAction)close:(id)sender
{
    [self.source dismissViewControllerAnimated:YES
                                    completion:nil];
}

- (IBAction)doLoginAction:(id)sender
{
    self.loginVc.view.alpha = 1;
    self.registerVc.view.alpha = 0;

    [self.scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
}

- (IBAction)doRegisterAction:(id)sender
{
    self.loginVc.view.alpha = 0;
    self.registerVc.view.alpha = 1;

    [self.scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
}

- (IBAction)onSinaButton:(id)sender
{
    [self.view showToastWithText:@"新浪" time:2.0];
}

- (IBAction)onTencentButton:(id)sender
{
    [self.view showToastWithText:@"QQ" time:2.0];
}

- (IBAction)onWechatButton:(id)sender
{
    [self.view showToastWithText:@"微信" time:2.0];
}

#pragma mark - Private Methods

- (void)configViews
{
    LoginAnimationView *animationView = [LoginAnimationView animation];
    [self.view insertSubview:animationView atIndex:0];

    [self.navigationView removeFromSuperview];
}

- (void)setupActionBinds
{
    RACChannelTo(self.loginButton, highlighted) = RACChannelTo(self.arrowButton, highlighted);
}

- (void)setupLayoutConstraints
{
    self.mainViewWidthConstraint.constant = kScreenWidth;

    [self.contentView addSubview:self.registerVc.view];
    [self.contentView addSubview:self.loginVc.view];
    [self.contentView addSubview:self.mobileVc.view];
    [self.contentView addSubview:self.mailVc.view];

    @weakify(self);
    [self.loginVc.view mas_makeConstraints:^(MASConstraintMaker *make) {

        @strongify(self);
        make.left.equalTo(self.mainView.mas_right);
        make.top.and.bottom.equalTo(self.contentView);
        make.width.equalTo(@(kScreenWidth));
    }];

    [self.registerVc.view mas_makeConstraints:^(MASConstraintMaker *make) {

        @strongify(self);
        make.left.equalTo(self.mainView.mas_right);
        make.top.and.bottom.equalTo(self.contentView);
        make.width.equalTo(@(kScreenWidth));
    }];

    [self.mobileVc.view mas_makeConstraints:^(MASConstraintMaker *make) {

        @strongify(self);
        make.left.equalTo(self.loginVc.view.mas_right);
        make.top.and.bottom.equalTo(self.contentView);
        make.width.equalTo(@(kScreenWidth));
    }];

    [self.mailVc.view mas_makeConstraints:^(MASConstraintMaker *make) {

        @strongify(self);
        make.left.equalTo(self.mobileVc.view.mas_right);
        make.top.and.bottom.equalTo(self.contentView);
        make.width.equalTo(@(kScreenWidth));
    }];

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {

        @strongify(self);
        make.right.equalTo(self.mailVc.view.mas_right);
    }];
}

#pragma mark - Getters & Setters

- (LoginViewController *)loginVc
{
    if (!_loginVc)
    {
        _loginVc = (LoginViewController *)[UIViewController controllerWithStoryboardName:kLogin_Storyboard_Name storyboardIdentifier:kLogin_LoginController_Identifier];
        _loginVc.delegate = self;
    }

    return _loginVc;
}

- (RegisterViewController *)registerVc
{
    if (!_registerVc)
    {
        _registerVc = (RegisterViewController *)[UIViewController controllerWithStoryboardName:kLogin_Storyboard_Name storyboardIdentifier:kLogin_RegisterController_Identifier];
        _registerVc.delegate = self;
    }

    return _registerVc;
}

- (FindPasswordViewController *)mobileVc
{
    if (!_mobileVc)
    {
        _mobileVc = (FindPasswordViewController *)[UIViewController controllerWithStoryboardName:kLogin_Storyboard_Name storyboardIdentifier:kLogin_MobileController_Identifier];
        _mobileVc.delegate = self;
    }

    return _mobileVc;
}

- (MailFindPasswordViewController *)mailVc
{
    if (!_mailVc)
    {
        _mailVc = (MailFindPasswordViewController *)[UIViewController controllerWithStoryboardName:kLogin_Storyboard_Name storyboardIdentifier:kLogin_EmailController_Identifier];
        _mailVc.delegate = self;
    }

    return _mailVc;
}

@end

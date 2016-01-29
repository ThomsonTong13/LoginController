//
//  LoginBaseViewController.m
//
//  Created by Thomson on 15/8/13.
//  Copyright (c) 2015年 Kemi. All rights reserved.
//

#import "LoginBaseViewController.h"

@interface LoginBaseViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton *backButton;

@end

@implementation LoginBaseViewController

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configCommonViews];
    [self setupCommonLayoutConstrints];
    [self setupCommonActionBinds];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark - private methods

- (void)configCommonViews
{
    [self.view addSubview:self.navigationView];
    [self.navigationView addSubview:self.backButton];

    UITapGestureRecognizer *onTapView = [[UITapGestureRecognizer alloc] init];
    [[onTapView rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *recognizer) {

        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    }];
//    [self.backgroundImageView addGestureRecognizer:onTapView];

    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setupCommonLayoutConstrints
{
    @weakify(self);
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {

        @strongify(self);
        make.top.equalTo(self.view).with.offset(15);
        make.left.and.right.equalTo(self.view);
        make.height.equalTo(@44);
    }];

    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {

        @strongify(self);
        make.top.and.bottom.equalTo(self.navigationView);
        make.left.equalTo(self.navigationView.mas_left).with.offset(15);
        make.width.equalTo(@44);
    }];
}

- (void)setupCommonActionBinds
{
    @weakify(self);
    [RACObserve(self, popCommand)
     subscribeNext:^(id x) {

         @strongify(self);
         self.backButton.rac_command = x;
     }];
}

#pragma mark - Override Methods

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Getters and Setters

- (UIView *)navigationView
{
    if (!_navigationView)
    {
        _navigationView = [UIView new];
        _navigationView.backgroundColor = [UIColor clearColor];
    }

    return _navigationView;
}

- (UIButton *)backButton
{
    if (!_backButton)
    {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.backgroundColor = [UIColor clearColor];
        [_backButton setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
        [_backButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        _backButton.rac_command = self.popCommand;
    }

    return _backButton;
}

- (RACCommand *)popCommand
{
    if (!_popCommand)
    {
        @weakify(self);
        _popCommand = [[RACCommand alloc]
                        initWithSignalBlock:^RACSignal *(id input) {

                            @strongify(self);
                            [self.navigationController popViewControllerAnimated:YES];

                            return [RACSignal empty];
                        }];
    }

    return _popCommand;
}

@end

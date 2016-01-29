//
//  RegisterViewController.m
//
//  Created by Thomson on 15/8/13.
//  Copyright (c) 2015年 Kemi. All rights reserved.
//

#import "RegisterViewController.h"
#import "VerificationButton.h"

@interface RegisterViewController () <UITextFieldDelegate>
{
    NSInteger   _countDown;
    BOOL        _isGetting;
}

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (weak, nonatomic) IBOutlet UITextField *mobileField;
@property (weak, nonatomic) IBOutlet UITextField *authCodeField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@property (weak, nonatomic) IBOutlet UIButton *eyeButton;

@property (weak, nonatomic) IBOutlet UIView *verificationBackground;
@property (nonatomic, strong) VerificationButton *verificationButton;

@property (nonatomic, strong) RACSignal *registerValidSignal;

@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configViews];
    [self setupLayoutConstraints];
    [self setupActionBinds];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Event Response

- (IBAction)doRegisterButton:(id)sender
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (IBAction)onEyeButton:(id)sender
{
    self.eyeButton.selected = !self.eyeButton.selected;
    self.passwordField.secureTextEntry = !self.eyeButton.selected;
}

- (void)onVerificationButton:(id)sender
{
    if (self.verificationButton.status == VerificationButtonStatusNormal)
    {
        _countDown = 60;
        _isGetting = YES;
        self.verificationButton.second = _countDown;

        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
    }
}

#pragma mark - Private Methods

- (void)configViews
{
    [self.verificationBackground addSubview:self.verificationButton];

    self.view.backgroundColor = [UIColor clearColor];
}

- (void)setupLayoutConstraints
{
    @weakify(self);
    [self.verificationButton mas_makeConstraints:^(MASConstraintMaker *make) {

        @strongify(self);
        make.edges.equalTo(self.verificationBackground);
    }];
}

- (void)setupActionBinds
{
    @weakify(self);
    [self.mobileField.rac_textSignal
     subscribeNext:^(NSString *x) {

         @strongify(self);
         self.verificationButton.enabled = [x isValidMobile] && !_isGetting;
     }];

    [self.passwordField.rac_textSignal
     subscribeNext:^(NSString *x) {

         @strongify(self);
         if (x.length > 0) self.eyeButton.hidden = NO;
     }];

    [[self.registerButton.rac_command.executionSignals
      flatten]
      subscribeNext:^(NSString *status) {

          if (self.delegate && [self.delegate respondsToSelector:@selector(loginFinished)])
          {
              [self.delegate loginFinished];
          }
      }];

    [[self registerValidSignal]
      subscribeNext:^(NSNumber *x) {

          @strongify(self);
          self.registerButton.enabled = x.boolValue;
      }];

    self.popCommand = [[RACCommand alloc]
                        initWithSignalBlock:^RACSignal *(id input) {

                            if (self.delegate && [self.delegate respondsToSelector:@selector(pop:)])
                            {
                                [self.delegate pop:self];
                            }

                            return [RACSignal empty];
                        }];
}

- (void)countDown:(NSTimer *)timer
{
    _countDown--;
    self.verificationButton.second = _countDown;

    if (_countDown < 0)
    {
        [timer invalidate];
        _isGetting = NO;
    }
}

#pragma mark - Getters & Setters

- (VerificationButton *)verificationButton
{
    if (!_verificationButton)
    {
        _verificationButton = [VerificationButton buttonWithType:UIButtonTypeCustom];
        [_verificationButton addTarget:self action:@selector(onVerificationButton:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _verificationButton;
}

- (RACSignal *)registerValidSignal
{
    if (!_registerValidSignal)
    {
        _registerValidSignal = [RACSignal
                                combineLatest:@[ self.mobileField.rac_textSignal,
                                                 self.authCodeField.rac_textSignal,
                                                 self.passwordField.rac_textSignal,
                                                 self.usernameField.rac_textSignal]
                                reduce:^id (NSString *mobileNumber, NSString *authCode, NSString *password, NSString *username) {

                                    return @([mobileNumber isValidMobile] && authCode.length > 0 && password.length > 0 && username.length > 0);
                                }];
    }

    return _registerValidSignal;
}


@end

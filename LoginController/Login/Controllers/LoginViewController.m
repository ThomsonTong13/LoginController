//
//  LoginViewController.m
//
//  Created by Thomson on 15/8/13.
//  Copyright (c) 2015年 Kemi. All rights reserved.
//

#import "LoginViewController.h"
#import "FindPasswordViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *line;
@property (weak, nonatomic) IBOutlet UIButton *eyeButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (nonatomic, strong) RACSignal *loginValidSignal;

@end

@implementation LoginViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configViews];
    [self setupActionBinds];
}

- (void)dealloc
{
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}

#pragma mark - Event Response

- (IBAction)forgetPassword:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(push:)])
    {
        [self.delegate push:self];
    }
}

- (IBAction)onEyeButton:(id)sender
{
    self.eyeButton.selected = !self.eyeButton.selected;
    self.passwordField.secureTextEntry = !self.eyeButton.selected;
}

#pragma mark - Private Methods

- (void)configViews
{
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)setupActionBinds
{
    @weakify(self);
    RACChannelTo(self.button, highlighted) = RACChannelTo(self.line, highlighted);

    [self.passwordField.rac_textSignal
     subscribeNext:^(NSString *x) {

         @strongify(self);
         if (x.length > 0) self.eyeButton.hidden = NO;
     }];

    [[self loginValidSignal]
      subscribeNext:^(NSNumber *x) {

          @strongify(self);
          self.loginButton.enabled = x.boolValue;
      }];

    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside]
      subscribeNext:^(id x) {

          @strongify(self);
          if (self.delegate && [self.delegate respondsToSelector:@selector(loginFinished)])
          {
              [self.delegate loginFinished];
          }
      }];

    self.popCommand = [[RACCommand alloc]
                        initWithSignalBlock:^RACSignal *(id input) {

                            @strongify(self);
                            if (self.delegate && [self.delegate respondsToSelector:@selector(pop:)])
                            {
                                [self.delegate pop:self];
                            }

                            return [RACSignal empty];
                        }];

    self.userField.delegate = self;
    self.passwordField.delegate = self;
}

#pragma mark - Getters & Setters

- (RACSignal *)loginValidSignal
{
    if (!_loginValidSignal)
    {
        _loginValidSignal = [RACSignal
                             combineLatest:@[ self.userField.rac_textSignal,
                                              self.passwordField.rac_textSignal ]
                             reduce:^id (NSString *username, NSString *password) {

                                 return @(username.length > 0 && password.length > 0);
                             }];
    }

    return _loginValidSignal;
}

@end

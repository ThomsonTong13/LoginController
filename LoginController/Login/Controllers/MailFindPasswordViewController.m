//
//  MailFindPasswordViewController.m
//
//  Created by Thomson on 15/8/17.
//  Copyright (c) 2015年 Kemi. All rights reserved.
//

#import "MailFindPasswordViewController.h"

#import "FindPasswordButton.h"

@interface MailFindPasswordViewController ()

@property (weak, nonatomic) IBOutlet UIView *buttonBackground;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *mobileButton;
@property (weak, nonatomic) IBOutlet UIButton *line;

@property (nonatomic, strong) FindPasswordButton *button;

@property (nonatomic, strong) RACDisposable *disposable;
@property (nonatomic, strong) RACSignal *emailValidSignal;

@end

@implementation MailFindPasswordViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configViews];
    [self setupLayoutConstraints];
    [self setupActionBinds];
}

- (void)dealloc
{
    
}

#pragma mark - Event Response

- (IBAction)onMobileButton:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(push:)])
    {
        [self.delegate push:self];
    }
}

- (void)onButton:(id)sender
{
    if (self.button.status == FindPasswordButtonStatusNormal)
    {
        @weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            @strongify(self);
            self.button.status = FindPasswordButtonStatusComplete;
        });

        self.button.status = FindPasswordButtonStatusSending;
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
        self.button.status = FindPasswordButtonStatusNormal;
    }

    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - Private Methods

- (void)configViews
{
    [self.buttonBackground addSubview:self.button];

    self.view.backgroundColor = [UIColor clearColor];
}

- (void)setupLayoutConstraints
{
    @weakify(self);
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {

        @strongify(self);
        make.edges.equalTo(self.buttonBackground);
    }];
}

- (void)setupActionBinds
{
    @weakify(self);
    RACChannelTo(self.mobileButton, highlighted) = RACChannelTo(self.line, highlighted);

    [[[self emailValidSignal]
       deliverOnMainThread]
       subscribeNext:^(NSNumber *x) {

           @strongify(self);
           self.button.enabled = x.boolValue;
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

- (RACSignal *)emailValidSignal
{
    if (!_emailValidSignal)
    {
        _emailValidSignal = [self.textField.rac_textSignal
                             map:^id(NSString *email) {

                                 return @([email isValidEmail]);
                             }];
    }
    
    return _emailValidSignal;
}

@end

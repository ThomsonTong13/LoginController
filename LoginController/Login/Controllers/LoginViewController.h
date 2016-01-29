//
//  LoginViewController.h
//
//  Created by Thomson on 15/8/13.
//  Copyright (c) 2015年 Kemi. All rights reserved.
//

#import "LoginBaseViewController.h"

@protocol LoginViewControllerDelegate;

@interface LoginViewController : LoginBaseViewController

@property (nonatomic, weak) id<LoginViewControllerDelegate> delegate;

@end

@protocol LoginViewControllerDelegate <NSObject>

- (void)pop:(id)controller;

- (void)push:(id)controller;

- (void)loginFinished;

@end

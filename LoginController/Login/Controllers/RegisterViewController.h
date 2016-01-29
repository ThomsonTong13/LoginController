//
//  RegisterViewController.h
//
//  Created by Thomson on 15/8/13.
//  Copyright (c) 2015年 Kemi. All rights reserved.
//

#import "LoginBaseViewController.h"

@protocol RegisterViewControllerDelegate;

@interface RegisterViewController : LoginBaseViewController

@property (nonatomic, weak) id<RegisterViewControllerDelegate> delegate;

@end

@protocol RegisterViewControllerDelegate <NSObject>

- (void)pop:(id)controller;
- (void)loginFinished;

@end

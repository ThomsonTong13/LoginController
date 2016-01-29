//
//  MailFindPasswordViewController.h
//
//  Created by Thomson on 15/8/17.
//  Copyright (c) 2015年 Kemi. All rights reserved.
//

#import "LoginBaseViewController.h"

@class FindPasswordViewModel;
@protocol MailViewControllerDelegate;

@interface MailFindPasswordViewController : LoginBaseViewController

@property (nonatomic, weak) id<MailViewControllerDelegate> delegate;

@end

@protocol MailViewControllerDelegate <NSObject>

- (void)push:(id)controller;

- (void)pop:(id)controller;

- (void)loginFinished;

@end

//
//  FindPwdByTelViewController.h
//
//  Created by Thomson on 15/8/14.
//  Copyright (c) 2015年 Kemi. All rights reserved.
//

#import "LoginBaseViewController.h"

@protocol MobileViewControllerDelegate;

@interface FindPasswordViewController : LoginBaseViewController

@property (nonatomic, weak) id<MobileViewControllerDelegate> delegate;

@end

@protocol MobileViewControllerDelegate <NSObject>

- (void)push:(id)controller;

- (void)pop:(id)controller;

- (void)loginFinished;

@end

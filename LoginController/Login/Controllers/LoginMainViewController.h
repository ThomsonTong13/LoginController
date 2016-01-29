//
//  LoginMainViewController.h
//
//  Created by Thomson on 15/12/23.
//  Copyright © 2015年 KEMI. All rights reserved.
//

#import "LoginBaseViewController.h"

@interface LoginMainViewController : LoginBaseViewController

@property (nonatomic, weak) id source;

+ (void)showLoginViewController:(UIViewController *)controller;

@end

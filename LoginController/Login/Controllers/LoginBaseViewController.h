//
//  LoginBaseViewController.h
//  Miban
//
//  Created by Thomson on 15/8/13.
//  Copyright (c) 2015年 Kemi. All rights reserved.
//

#import "UIImage+LMExtension.h"
#import "UIViewController+Identifier.h"
#import "UIView+Toast.h"
#import "NSString+IsValid.h"
#import "AppMacros.h"
#import "UtilsMacros.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>

@protocol LoginMainViewControllerDelegate;

@interface LoginBaseViewController : UIViewController

@property (nonatomic, strong) RACCommand *popCommand;
@property (nonatomic, strong) UIView *navigationView;

@end

@protocol LoginMainViewControllerDelegate <NSObject>
- (void)loginFinished;
@end

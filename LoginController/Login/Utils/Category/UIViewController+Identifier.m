//
//  UIViewController+Identifier.m
//
//  Created by Thomson on 15/8/7.
//  Copyright (c) 2015年 Kemi. All rights reserved.
//

#import "UIViewController+Identifier.h"

@implementation UIViewController (Identifier)

+ (instancetype)controllerWithStoryboardName:(NSString *)storyboardName storyboardIdentifier:(NSString *)identifier
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:identifier];

    return controller;
}

@end

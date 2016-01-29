//
//  UIViewController+Identifier.h
//
//  Created by Thomson on 15/8/7.
//  Copyright (c) 2015年 Kemi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Identifier)

+ (instancetype)controllerWithStoryboardName:(NSString *)storyboardName storyboardIdentifier:(NSString *)identifier;

@end

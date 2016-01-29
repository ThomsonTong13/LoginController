//
//  FindPasswordButton.h
//
//  Created by Thomson on 15/12/24.
//  Copyright © 2015年 KEMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

typedef NS_ENUM(NSInteger, FindPasswordButtonStatus) {
    FindPasswordButtonStatusNormal,
    FindPasswordButtonStatusSending,
    FindPasswordButtonStatusComplete,
    FindPasswordButtonStatusError
};

@interface FindPasswordButton : UIButton

@property (nonatomic, assign) FindPasswordButtonStatus status;
@property (nonatomic, strong) NSString *text;

@end

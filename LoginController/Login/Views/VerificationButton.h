//
//  VerificationButton.h
//
//  Created by Thomson on 15/12/28.
//  Copyright © 2015年 KEMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

typedef NS_ENUM(NSInteger, VerificationButtonStatus) {
    VerificationButtonStatusNormal,
    VerificationButtonStatusSending,
    VerificationButtonStatusComplete
};

@interface VerificationButton : UIButton

@property (nonatomic, assign, readonly) VerificationButtonStatus status;
@property (nonatomic, assign) NSInteger second;

@end

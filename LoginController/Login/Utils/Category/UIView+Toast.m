//
//  UIView+Toast.m
//
//  Created by Thomson on 15/7/6.
//  Copyright (c) 2015年 Kemi. All rights reserved.
//

#import "UIView+Toast.h"

@implementation UIView (Toast)

- (void)showToastWithText:(NSString *)text time:(NSTimeInterval)time
{
    CGFloat maxWidth = self.window.bounds.size.width - 110.0f;

    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor colorWithWhite:.3f alpha:.7f];
    label.textColor = [UIColor whiteColor];
    label.layer.cornerRadius = 5.0f;
    label.layer.masksToBounds = YES;

    label.text = text;

    CGSize size = CGSizeMake(maxWidth, CGFLOAT_MAX);

    CGRect rect = [label.text boundingRectWithSize:size
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{ NSFontAttributeName :label.font }
                                           context:nil];

    rect.size.height = MAX(40.0f, rect.size.height + 32.0f);
    rect.size.width += 32.0f;
    rect.origin.y = (self.window.bounds.size.height - rect.size.height) / 2;
    rect.origin.x = (self.window.bounds.size.width - rect.size.width) / 2;

    label.frame = rect;

    [self.window addSubview:label];

    [UIView animateWithDuration:.5f
                          delay:time
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            label.alpha = 0;
                        }
                     completion:^(BOOL finished) {
                         [label removeFromSuperview];
                     }];
}

@end

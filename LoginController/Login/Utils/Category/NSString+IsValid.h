//
//  NSString+IsValid.h
//  LoginController
//
//  Created by Thomson on 16/1/28.
//  Copyright © 2016年 Thomson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IsValid)

/**
 *  Valid a email string.
 *
 *  @return `YES` if email is valid.
 */
- (BOOL)isValidEmail;

/**
 *  Valid a Telephone string.
 *
 *  @return `YES` if telephone is valid.
 */
- (BOOL)isValidMobile;

@end

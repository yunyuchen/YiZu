//
//  YYUserManager.h
//  BikeRental
//
//  Created by yunyuchen on 2017/5/23.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYUserManager : NSObject


+ (void) saveToken:(id)token;

/**
 *  判断是否已经登录
 *
 *  @return YES or NO
 */
+ (BOOL)isHaveLogin;

/**
 *  获取用户基本信息
 */
- (void)fetchUser;

+(void) logout;

@end

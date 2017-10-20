//
//  YYUserManager.m
//  BikeRental
//
//  Created by yunyuchen on 2017/5/23.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYUserManager.h"
#import "YYFileCacheManager.h"

@implementation YYUserManager

/**
 *  判断是否已经登录
 *
 *  @return YES or NO
 */
+ (BOOL)isHaveLogin
{
    if (kFetchUserId != nil)
    {
        NSString * str = [NSString stringWithFormat:@"%@",kFetchUserId];
        if (![str isEqualToString:@"0"]) {
            return YES;
        }

    }
    return NO;
}

+(BOOL)passCheck
{
    if ([YYFileCacheManager readUserDataForKey:kPassCheckKey]) {
        return YES;
    }
    return NO;
}

/**
 *  记录用户token
 *
 */
+(void)saveToken:(id)token
{
    //记录Token
    [YYFileCacheManager saveUserData:[NSString stringWithFormat:@"%@",token] forKey:kTokenKey];
}

-(void)fetchUser
{
    
}

+(void)logout
{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    //清除用户信息
    [YYFileCacheManager removeUserDataForkey:kUserInfoKey];
    //清除token
    [YYFileCacheManager removeUserDataForkey:kTokenKey];
    
    [YYFileCacheManager removeUserDataForkey:kPassCheckKey];
    //发送退出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutSuccessNotification object:nil];
}


@end

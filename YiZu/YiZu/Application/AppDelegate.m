//
//  AppDelegate.m
//  RPXK
//
//  Created by yunyuchen on 2017/9/25.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "AppDelegate.h"
#import "QMUIConfigurationTemplate.h"
#import "YYBaseRequest.h"
#import "YYUserManager.h"
#import "WXApiManager.h"
#import "NSNotificationCenter+Addition.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <QMUIKit.h>
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[[QMUIConfigurationTemplate alloc] init] setupConfigurationTemplate];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    [AMapServices sharedServices].apiKey = kAMapKey;
    [[AMapServices sharedServices] setEnableHTTPS:NO];
    
    if ([YYUserManager passCheck]) {
        QMUINavigationController *mainViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"main"];
        self.window.rootViewController = mainViewController;
    }

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // 其他如支付等SDK的回调
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
    
    
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSString *message = @"";
            switch([[resultDic objectForKey:@"resultStatus"] integerValue])
            {
                case 9000:
                {
                    message = @"订单支付成功";
                    
                    [NSNotificationCenter postNotification:kPayDesSuccessNotification];
                    QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
                    
                    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
                    contentView.minimumSize = CGSizeMake(300, 100);
                    [tips showSucceed:message hideAfterDelay:3];
                    return;
                }
                case 8000:
                {
                    message = @"正在处理中";
                    break;
                }
                case 4000:message = @"订单支付失败";break;
                case 6001:{
                    [NSNotificationCenter postNotification:kPayDesCancelNotification];
                    return;
                }
                case 6002:message = @"网络连接错误";break;
                default:message = @"未知错误";
            }
            
            
            QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
            
            QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
            contentView.minimumSize = CGSizeMake(300, 100);
            [tips showInfo:message hideAfterDelay:3];
        }];
    }
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    return YES;
}



@end

//
//  YYControlBikeViewController.h
//  BikeRental
//
//  Created by yunyuchen on 2017/6/14.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMUIKit.h>

@interface YYControlBikeViewController : QMUICommonViewController

@property (nonatomic,copy) NSString *ctime;

@property (nonatomic,assign) NSInteger deviceid;

@property (nonatomic,assign) CGFloat last_mileage;

@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,copy) NSString *name;

@end

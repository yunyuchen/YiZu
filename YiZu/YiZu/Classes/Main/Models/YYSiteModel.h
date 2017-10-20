//
//  YYSiteModel.h
//  BikeRental
//
//  Created by yunyuchen on 2017/5/22.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseModel.h"

@interface YYSiteModel : YYBaseModel

//"id": 6,
//"distance": 457.37703189359877,
//"count": 0,
//"address": "常州科教城",
//"name": "科教城",
//"longitude": 119.963794,
//"latitude": 31.682134
@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,assign) CGFloat distance;

@property (nonatomic,assign) NSInteger count;

@property (nonatomic,copy) NSString *address;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,assign) CGFloat longitude;

@property (nonatomic,assign) CGFloat latitude;

@property (nonatomic,copy) NSString *img1;

@property (nonatomic,copy) NSString *img2;

@property (nonatomic,assign) BOOL nearest;

@end

//
//  YYRentalModel.h
//  BikeRental
//
//  Created by yunyuchen on 2017/5/16.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseModel.h"

@interface YYRentalModel : YYBaseModel

@property (nonatomic,assign) BOOL selected;

@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,assign) NSInteger sid;

@property (nonatomic,assign) NSInteger ssid;

@property (nonatomic,assign) CGFloat lon;

@property (nonatomic,assign) CGFloat lat;

@property (nonatomic,copy) NSString *bleid;

@property (nonatomic,assign) NSInteger state;

@property (nonatomic,assign) NSInteger did;

@property (nonatomic,assign) CGFloat last_mileage;

@property (nonatomic,assign) CGFloat last_percent;

@property (nonatomic,copy) NSString *ctime;

@property (nonatomic,assign) NSInteger muid;

@property (nonatomic,assign) NSInteger deviceid;

@property (nonatomic,assign) CGFloat price;

@property (nonatomic,assign) NSInteger keep;

@property (nonatomic,copy) NSString *name;
@end

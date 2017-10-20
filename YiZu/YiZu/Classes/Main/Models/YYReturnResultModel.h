//
//  YYReturnResultModel.h
//  BikeRental
//
//  Created by yunyuchen on 2017/5/25.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYBaseModel.h"

@interface YYReturnResultModel : YYBaseModel

@property (nonatomic,assign) CGFloat price;

@property (nonatomic,assign) NSInteger keep;

@property (nonatomic,assign) CGFloat extPrice;

@property (nonatomic,assign) CGFloat longitude;

@property (nonatomic,assign) CGFloat latitude;

@property (nonatomic,assign) CGFloat first;

@end

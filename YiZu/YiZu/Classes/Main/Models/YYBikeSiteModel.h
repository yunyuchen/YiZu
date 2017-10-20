//
//  YYBikeSiteModel.h
//  YiZu
//
//  Created by yunyuchen on 2017/10/19.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "YYBaseModel.h"

@interface YYBikeSiteModel : YYBaseModel
//address = "\U5e38\U5dde\U79d1\U6559\U57ce\U56fd\U9645\U521b\U65b0\U57fa\U5730510\U5927\U9053";
//distance = "30.80388167501665";
//id = 7;
//img1 = "/upload/site/20171018/RBCY.jpg";
//latitude = "31.68093";
//longitude = "119.968873";
//name = "2A1302\U529e\U516c\U5ba4";
@property(nonatomic, copy) NSString *address;

@property(nonatomic, copy) NSString *distance;

@property(nonatomic, assign) NSInteger ID;

@property(nonatomic, copy) NSString *img1;

@property(nonatomic, assign) CGFloat latitude;

@property(nonatomic, assign) CGFloat longitude;

@property(nonatomic, copy) NSString *name;

@end

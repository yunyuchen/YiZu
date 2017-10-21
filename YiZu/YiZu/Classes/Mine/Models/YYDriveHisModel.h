//
//  YYDriveHisModel.h
//  YiZu
//
//  Created by yunyuchen on 2017/10/20.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "YYBaseModel.h"

@interface YYDriveHisModel : YYBaseModel


@property (nonatomic,assign) CGFloat price;

@property (nonatomic,copy) NSString *rname;

@property (nonatomic,copy) NSString *sname;

@property (nonatomic,copy) NSString *ctime;

@property (nonatomic,assign) NSInteger keep;

@end

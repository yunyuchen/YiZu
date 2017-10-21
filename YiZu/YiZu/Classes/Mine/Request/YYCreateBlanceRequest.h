//
//  YYCreateBlanceRequest.h
//  YiZu
//
//  Created by yunyuchen on 2017/10/20.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "YYBaseRequest.h"

@interface YYCreateBlanceRequest : YYBaseRequest

@property (nonatomic,assign) NSInteger ptype;

@property (nonatomic,assign) CGFloat price;

@end

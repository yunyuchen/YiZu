//
//  YYUserauthRequest.h
//  YiZu
//
//  Created by yunyuchen on 2017/10/18.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "YYBaseRequest.h"

@interface YYUserauthRequest : YYBaseRequest

@property(nonatomic, copy) NSString *idcard;

@property(nonatomic, copy) NSString *name;

@end

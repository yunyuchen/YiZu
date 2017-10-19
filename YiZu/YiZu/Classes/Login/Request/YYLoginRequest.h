//
//  YYLoginRequest.h
//  RowRabbit
//
//  Created by 恽雨晨 on 2016/12/27.
//  Copyright © 2016年 常州云阳驱动. All rights reserved.
//

#import "YYBaseRequest.h"

@interface YYLoginRequest : YYBaseRequest

@property (nonatomic,copy) NSString *tel;

@property (nonatomic,copy) NSString *code;

@property (nonatomic,copy) NSString *inviteid;

@end

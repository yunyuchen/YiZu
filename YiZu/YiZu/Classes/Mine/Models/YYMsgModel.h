//
//  YYMsgModel.h
//  YiZu
//
//  Created by yunyuchen on 2017/10/20.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "YYBaseModel.h"

@interface YYMsgModel : YYBaseModel

@property (nonatomic,copy) NSString *content;

@property (nonatomic,copy) NSString *ctime;

@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,assign) NSInteger state;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,assign) NSInteger type;

@property (nonatomic,assign) NSInteger uid;

@property (nonatomic,copy) NSString *url;


@end

//
//  NSDictionary+dealNullValue.h
//  cheyongwang
//
//  Created by yunyuchen on 15/12/9.
//  Copyright © 2015年 yunyuchen. All rights reserved.
//

#import <Foundation/Foundation.h>

//处理空值

@interface NSDictionary (dealNullValue)

+(NSDictionary *)nullDic:(NSDictionary *)myDic;
+(NSArray *)nullArr:(NSArray *)myArr;
+(NSString *)stringToString:(NSString *)string;
+(NSString *)nullToString;
+(id)changeType:(id)myObj;
@end

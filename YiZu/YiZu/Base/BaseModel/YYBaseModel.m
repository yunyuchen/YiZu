//
//  YYBaseModel.m
//  RowRabbit
//
//  Created by 恽雨晨 on 2016/12/24.
//  Copyright © 2016年 常州云阳驱动. All rights reserved.
//

#import "YYBaseModel.h"
#import "MJExtension.h"
#import "YYFileCacheManager.h"

@implementation YYBaseModel

MJCodingImplementation;

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{
             @"ID":@"id",
             @"desc":@"description",
             @"responseData" : @"data"
             };
}

+ (NSMutableArray *)modelArrayWithDictArray:(NSArray *)response {
    if ([response isKindOfClass:[NSArray class]]) {
        NSMutableArray *array = [self mj_objectArrayWithKeyValuesArray:response];
        return array;
    }
    return [NSMutableArray new];
}

+ (id)modelWithDictionary:(NSDictionary *)dictionary {
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        return [self mj_objectWithKeyValues:dictionary];
    }
    return [[self alloc] init];
}

+ (void)setUpModelClassInArrayWithContainDict:(NSDictionary *)dict {
    if (dict.allKeys.count == 0) {
        return ;
    }
    [self mj_setupObjectClassInArray:^NSDictionary *{
        return dict;
    }];
}

+ (NSMutableArray *)modelArrayWithDictArray:(NSArray *)response containDict:(NSDictionary *)dict {
    if (dict == nil) {
        dict = [NSMutableDictionary new];
    }
    [self setUpModelClassInArrayWithContainDict:dict];
    return [self modelArrayWithDictArray:response];
}

+ (id)modelWithDictionary:(NSDictionary *)dictionary containDict:(NSDictionary *)dict {
    if (dict == nil) {
        dict = [NSMutableDictionary new];
    }
    [self setUpModelClassInArrayWithContainDict:dict];
    return [self modelWithDictionary:dictionary];
}

- (id)unarchiver {
    id obj = [YYFileCacheManager getObjectByFileName:[self.class description]];
    return obj;
}

- (void)archive {
    [YYFileCacheManager saveObject:self byFileName:[self.class description]];
}

- (void)remove {
    [YYFileCacheManager removeObjectByFileName:[self.class description]];
}


@end

//
//  YYBaseRequest.m
//  RowRabbit
//
//  Created by 恽雨晨 on 2016/12/23.
//  Copyright © 2016年 常州云阳驱动. All rights reserved.
//

#import "YYBaseRequest.h"
#import "YYRequestManager.h"
#import "MJExtension.h"
#import "NSString+Addition.h"
#import "NSDictionary+Addition.h"
#import "AFNetworkReachabilityManager.h"
#import "NSNotificationCenter+Addition.h"


@implementation YYBaseRequest

#pragma mark - 构造
+ (instancetype)nh_request {
    return [[self alloc] init];
}

+ (instancetype)nh_requestWithUrl:(NSString *)nh_url {
    return [self nh_requestWithUrl:nh_url isPost:NO];
}

+ (instancetype)nh_requestWithUrl:(NSString *)nh_url isPost:(BOOL)nh_isPost {
    return [self nh_requestWithUrl:nh_url isPost:nh_isPost delegate:nil];
}

+ (instancetype)nh_requestWithUrl:(NSString *)nh_url isPost:(BOOL)nh_isPost delegate:(id <NHBaseRequestReponseDelegate>)nh_delegate {
    YYBaseRequest *request = [self nh_request];
    request.nh_url = nh_url;
    request.nh_isPost = nh_isPost;
    request.nh_delegate = nh_delegate;
    return request;
}

#pragma mark - 发送请求
- (void)nh_sendRequest {
    [self nh_sendRequestWithCompletion:nil];
}

- (void)nh_sendRequestWithCompletion:(NHAPIDicCompletion)completion {
    
    // 链接
    NSString *urlStr = self.nh_url;
    if (urlStr.length == 0) return ;
    
    // 参数
    NSDictionary *params = [self params];
    
    // 普通POST请求
    if (self.nh_isPost) {
        if (self.nh_imageArray.count == 0) {
            // 开始请求
            [YYRequestManager POST:[urlStr noWhiteSpaceString] parameters:params responseSeializerType:NHResponseSeializerTypeJSON success:^(id responseObject) {
                
                // 处理数据
                [self handleResponse:responseObject completion:completion];
            } failure:^(NSError *error) {
                
                // 数据请求失败，暂时不做处理
            }];
        }
        
    } else { // 普通GET请求
        // 开始请求
        [YYRequestManager GET:[urlStr noWhiteSpaceString] parameters:params responseSeializerType:NHResponseSeializerTypeJSON success:^(id responseObject) {
            
            // 处理数据
            [self handleResponse:responseObject completion:completion];
        } failure:^(NSError *error) {
            // 数据请求失败，暂时不做处理
            
        }];
    }
    
    // 上传图片
    if (self.nh_imageArray.count) {
        [YYRequestManager POST:[urlStr noWhiteSpaceString] parameters:params responseSeializerType:NHResponseSeializerTypeJSON constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSInteger imgCount = 0;
            for (UIImage *image in self.nh_imageArray) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss:SSS";
                NSString *fileName = [NSString stringWithFormat:@"%@%@.png",[formatter stringFromDate:[NSDate date]],@(imgCount)];
                [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:[NSString stringWithFormat:@"%@file",[formatter stringFromDate:[NSDate date]]] fileName:fileName mimeType:@"image/png"];
                imgCount++;
            }
        } success:^(id responseObject) {
            // 处理数据
            [self handleResponse:responseObject completion:completion];
        } failure:^(NSError *error) {
            // 数据请求失败，暂时不做处理
            
        }];
    }
}

- (void)nh_sendRequestWithCompletion:(NHAPIDicCompletion)completion error:(NHAPIErrorCompletion) errorCompletion
{
    // 链接
    NSString *urlStr = self.nh_url;
    if (urlStr.length == 0) return ;
    
    // 参数
    NSDictionary *params = [self params];
    
    // 普通POST请求
    if (self.nh_isPost) {
        if (self.nh_imageArray.count == 0) {
            // 开始请求
            [YYRequestManager POST:[urlStr noWhiteSpaceString] parameters:params responseSeializerType:NHResponseSeializerTypeJSON success:^(id responseObject) {
                
                // 处理数据
                [self handleResponse:responseObject completion:completion];
            } failure:^(NSError *error) {
                if (error) {
                    errorCompletion(error);
                }
                // 数据请求失败，暂时不做处理
                
            }];
        }
        
    } else { // 普通GET请求
        // 开始请求
        [YYRequestManager GET:[urlStr noWhiteSpaceString] parameters:params responseSeializerType:NHResponseSeializerTypeJSON success:^(id responseObject) {
            
            // 处理数据
            [self handleResponse:responseObject completion:completion];
        } failure:^(NSError *error) {
            // 数据请求失败，暂时不做处理
            if (error) {
                errorCompletion(error);
            }
        }];
    }
    
    // 上传图片
    if (self.nh_imageArray.count) {
        [YYRequestManager POST:[urlStr noWhiteSpaceString] parameters:params responseSeializerType:NHResponseSeializerTypeJSON constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSInteger imgCount = 0;
            for (UIImage *image in self.nh_imageArray) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss:SSS";
                NSString *fileName = [NSString stringWithFormat:@"%@%@.png",[formatter stringFromDate:[NSDate date]],@(imgCount)];
                [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]] fileName:fileName mimeType:@"image/png"];
                imgCount++;
            }
        } success:^(id responseObject) {
            // 处理数据
            [self handleResponse:responseObject completion:completion];
        } failure:^(NSError *error) {
            // 数据请求失败，暂时不做处理
            if (error) {
                errorCompletion(error);
            }
        }];
    }

}

- (void)handleResponse:(id)responseObject completion:(NHAPIDicCompletion)completion {
    // 接口约定，如果message为retry即重试
    if ([responseObject[@"message"] isEqualToString:@"retry"]) {
        [self nh_sendRequestWithCompletion:completion];
        return  ;
    }
    // 数据请求成功回调
    BOOL success = [responseObject[@"state"] isEqualToString:@"000"];
    
//    NSLog(@"%@",kFetchUserId);
//    
//    if ([responseObject[@"state"] isEqualToString:@"503"] && kFetchUserInfo != nil) {
//        success = false;
//        
//        [SVProgressHUD showErrorWithStatus:@"您的账号在别处登录，请重新登录"];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutSuccessNotification object:nil];
//    }
    
   
    if (completion) {
        
        completion(responseObject[@"data"], success, responseObject[@"msg"]);
    } else if (self.nh_delegate) {
        if ([self.nh_delegate respondsToSelector:@selector(requestSuccessReponse:response:message:)]) {
            [self.nh_delegate requestSuccessReponse:success response:responseObject[@"data"] message:@""];
        }
    }
    // 请求成功，发布通知
    [NSNotificationCenter postNotification:kNHRequestSuccessNotification];
}

// 设置链接
- (void)setNh_url:(NSString *)nh_url {
    if (nh_url.length == 0 || [nh_url isKindOfClass:[NSNull class]]) {
        return ;
    }
    _nh_url = nh_url;
}

- (NSDictionary *)params {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addEntriesFromDictionary:self.mj_keyValues];
    
    if ([params.allKeys containsObject:@"nh_delegate"]) {
        [params removeObjectForKey:@"nh_delegate"];
    }
    if ([params.allKeys containsObject:@"nh_isPost"]) {
        [params removeObjectForKey:@"nh_isPost"];
    }
    if ([params.allKeys containsObject:@"nh_url"]) {
        [params removeObjectForKey:@"nh_url"];
    }
    if (self.nh_imageArray.count == 0) {
        if ([params.allKeys containsObject:@"nh_imageArray"]) {
            [params removeObjectForKey:@"nh_imageArray"];
        }
    }
    return params;
}



@end

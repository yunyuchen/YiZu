//
//  NSString+YYExtension.h
//  cheyongwang
//
//  Created by 恽雨晨 on 15/11/14.
//  Copyright © 2015年 恽雨晨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (YYExtension)

/**
 去除首尾空格
 */
- (NSString *) trim;
/**
   从普通字符串转换为16进制
 */
- (NSString *)changeToHexFromString;
/**
   从16进制转化为普通字符串
 */
- (NSString *)changeToStringFromHex;
/**
   获取当前的时间戳
 */
+(NSString *) timestamp;
/**
  从16进制转换为10进制
 */
- (NSString *)changeToDecimalFromHex;
/**
 NSDATA转换成16进制
 */
+ (NSString *)convertDataToHexStr:(NSData *)data;
/**
 16进制转换为NSDATA
 */
+ (NSData *)convertHexStrToData:(NSString *)str;
/**
 16进制转换为二进制
 */
-(NSString *)getBinaryByhex:(NSString *)hex;
/**
 生成随机数
 */
+ (NSString *)randomString;

- (NSInteger) fileSize;
+ (NSString *)documentPath;
+ (NSString *)cachePath;
+ (NSString *)formatCurDate;
+ (NSString *)formatCurDay;
+ (NSString *)getAppVer;
+ (NSString*)DataTOjsonString:(id)object;
- (NSString*)removeAllSpace;
- (NSURL *) toURL;
- (NSString *) escapeHTML;
- (NSString *) unescapeHTML;
- (NSString *) stringByRemovingHTML;
- (NSString *) MD5;
- (NSString *) URLEncode;

+ (NSString *)HMACMD5WithString:(NSString *)toEncryptStr WithKey:(NSString *)keyStr;

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

- (BOOL) isOlderVersionThan:(NSString*)otherVersion;
- (BOOL) isNewerVersionThan:(NSString*)otherVersion;
- (BOOL) isEmail;
- (BOOL) isEmpty;
@end

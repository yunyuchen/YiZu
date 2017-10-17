//
//  UIImage+YYExtension.h
//  RowRabbit
//
//  Created by 恽雨晨 on 2017/1/5.
//  Copyright © 2017年 常州云阳驱动. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YYExtension)

/**
 *  设置圆角头像
 *
 *  @param image 一张图片
 *
 *  @return 返回一张圆形的图片
 */
+(instancetype)circleImage :(UIImage *)image;

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size;
//保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;

- (NSString *) image2DataURL: (UIImage *) image;

+(UIImage *) circleImageWithImageName:(NSString *) name borderWidth:(CGFloat) width color:(UIColor*)bordercolor;

+(UIImage *) circleImageWithNetImageName:(UIImage *) image borderWidth:(CGFloat) width color:(UIColor*)bordercolor;

+ (UIImage *)strechImage:(NSString *)imageName;

+ (UIImage *)navigationBarBackgroundImageWithThemeColor:(UIColor *)color;
@end

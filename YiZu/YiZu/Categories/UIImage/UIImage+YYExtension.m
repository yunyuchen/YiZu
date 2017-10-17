//
//  UIImage+YYExtension.m
//  RowRabbit
//
//  Created by 恽雨晨 on 2017/1/5.
//  Copyright © 2017年 常州云阳驱动. All rights reserved.
//

#import "UIImage+YYExtension.h"
#import <QMUIConfiguration.h>
#import <UIColor+QMUI.h>

@implementation UIImage (YYExtension)

+(instancetype)circleImage:(UIImage *)image
{
    
    UIGraphicsBeginImageContext(image.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextAddEllipseInRect(ctx, rect);
    
    CGContextClip(ctx);
    
    [image drawInRect:rect];
    
    UIImage *tmpImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tmpImage;
    
    
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

- (BOOL) imageHasAlpha: (UIImage *) image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}
- (NSString *) image2DataURL: (UIImage *) image
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha: image]) {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
        mimeType = @"image/jpeg";
    }
    
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
            [imageData base64EncodedStringWithOptions: 0]];
    
}

+(UIImage *) circleImageWithImageName:(NSString *) name borderWidth:(CGFloat) width color:(UIColor*)bordercolor
{
    UIImage *image = [UIImage imageNamed:name];
    
    //CGFloat borderWidth = 5;
    
    CGSize size = CGSizeMake(image.size.width + 2 * width, image.size.height + 2 * width);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    UIBezierPath *bigCircle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
    
    [bordercolor set];
    
    [bigCircle fill];
    
    UIBezierPath *imgCircle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(width, width, image.size.width, image.size.height)];
    
    [imgCircle addClip];
    
    [image drawAtPoint:CGPointMake(width, width)];
    
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    
    return newImg;
    
}

+(UIImage *) circleImageWithNetImageName:(UIImage *) image borderWidth:(CGFloat) width color:(UIColor*)bordercolor
{
    
    CGSize size = CGSizeMake(image.size.width + 2 * width, image.size.height + 2 * width);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    UIBezierPath *bigCircle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
    
    [bordercolor set];
    
    [bigCircle fill];
    
    UIBezierPath *imgCircle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(width, width, image.size.width, image.size.height)];
    
    [imgCircle addClip];
    
    [image drawAtPoint:CGPointMake(width, width)];
    
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    
    return newImg;
    
}

+ (UIImage *)strechImage:(NSString *)imageName
{
    UIImage *img = [UIImage imageNamed:imageName];
    img = [img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
    return img;
}

+ (UIImage *)navigationBarBackgroundImageWithThemeColor:(UIColor *)color {
    CGSize size = CGSizeMake(4, 88);// iPhone X，navigationBar 背景图 88，所以直接用 88 的图，其他手机会取这张图在 y 轴上的 0-64 部分的图片
    UIImage *resultImage = nil;
    color = color ? color : [[QMUIConfiguration sharedInstance] clearColor];
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGGradientRef gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), (CFArrayRef)@[(id)color.CGColor, (id)[color qmui_colorWithAlphaAddedToWhite:.86].CGColor], NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(0, size.height), kCGGradientDrawsBeforeStartLocation);
    
    resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGGradientRelease(gradient);
    return [resultImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)];
}

@end

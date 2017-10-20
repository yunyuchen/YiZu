//
//  YYScrollAddressView.h
//  BikeRental
//
//  Created by yunyuchen on 2017/6/16.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYAddressView.h"
#import "YYSiteModel.h"

@class YYScrollAddressView;
@protocol ScrollAddressViewDelegate <NSObject>

-(void) navScrollView:(YYScrollAddressView *)scrollView didSelectCurrentModel:(YYSiteModel *)model;

@end

@interface YYScrollAddressView : UIView

@property(nonatomic,strong) UIScrollView *scrollView;

@property (strong, nonatomic) YYAddressView *imgVLeft;
@property (strong, nonatomic) YYAddressView *imgVCenter;
@property (strong, nonatomic) YYAddressView *imgVRight;
@property (assign, nonatomic) NSUInteger currentImageIndex;
@property (assign, nonatomic) NSUInteger imageCount;
@property (nonatomic,strong) NSArray<YYSiteModel *>* models;

- (void)setInfoByCurrentModelIndex:(NSUInteger)currentModelIndex;


@property (nonatomic,weak) id<ScrollAddressViewDelegate> delegate;
@end

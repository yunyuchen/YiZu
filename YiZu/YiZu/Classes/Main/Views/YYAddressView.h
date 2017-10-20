//
//  YYAddressView.h
//  BikeRental
//
//  Created by yunyuchen on 2017/6/16.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYSiteModel.h"

@class YYAddressView;
@protocol AddressViewDelegate <NSObject>

-(void) addressView:(YYAddressView *)addressView didClickReturnButton:(UIButton *)returnButton;

@end

@interface YYAddressView : UIView

@property (nonatomic,strong) YYSiteModel *model;

@property (nonatomic,weak) id<AddressViewDelegate> delegate;

@end

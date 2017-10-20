//
//  YYOrderInfoView.h
//  BikeRental
//
//  Created by yunyuchen on 2017/5/25.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYUserModel.h"

@class YYOrderInfoView,YYReturnResultModel;
@protocol OrderInfoViewDelegate <NSObject>
@optional
-(void) orderInfoView:(YYOrderInfoView *)orderView didClickOKButton:(UIButton *)sender;

-(void) orderInfoView:(YYOrderInfoView *)orderView didClickCloseButton:(UIButton *)sender;

-(void) orderInfoView:(YYOrderInfoView *)orderView didClickNaviButton:(UIButton *)sender withReturnModel:(YYReturnResultModel *)resultModel;

@end


@interface YYOrderInfoView : UIView

@property (nonatomic,assign) NSInteger rsid;

@property (nonatomic,copy) NSString *siteName;

@property (nonatomic,strong) YYUserModel *userModel;

@property (nonatomic,strong) YYReturnResultModel *resultModel;

@property (nonatomic,weak) id<OrderInfoViewDelegate> delegate;

@end

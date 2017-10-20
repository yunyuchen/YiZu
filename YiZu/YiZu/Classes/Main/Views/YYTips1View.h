//
//  YYTips1View.h
//  BikeRental
//
//  Created by yunyuchen on 2017/6/16.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYTips1View;
@protocol Tips1ViewDelegate <NSObject>

-(void) YYTips1View:(YYTips1View *)tipsView didClickReturnButton:(UIButton *)returnButton;

-(void) YYTips1View:(YYTips1View *)tipsView didClickCloseButton:(UIButton *)closeButton;

-(void) YYTips1View:(YYTips1View *)tipsView didClickFeedBackButton:(UIButton *)feedBackButton;

@end

@interface YYTips1View : UIView

@property (nonatomic,weak) id<Tips1ViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

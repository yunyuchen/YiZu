//
//  YYOrderInfoView.m
//  BikeRental
//
//  Created by yunyuchen on 2017/5/25.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYOrderInfoView.h"
#import "YYOrderInfoRequest.h"
#import "YYReturnResultModel.h"

@interface YYOrderInfoView()

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *extPrriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalFeeLabel;

@property (weak, nonatomic) IBOutlet UILabel *siteNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;

@end


@implementation YYOrderInfoView

-(void)awakeFromNib
{
    [super awakeFromNib];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
    }
    return self;
}


-(void)setResultModel:(YYReturnResultModel *)resultModel
{
    _resultModel = resultModel;
    
    NSInteger hour = self.resultModel.keep / 60;
    NSInteger minute = self.resultModel.keep % 60;

    self.totalTimeLabel.text = [NSString stringWithFormat:@"%ld时%ld分钟",hour,minute];
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.0f",self.resultModel.price];
    
    self.totalFeeLabel.text = [NSString stringWithFormat:@"¥%.0f",self.userModel.money - self.resultModel.price];
    
    self.siteNameLabel.text = [NSString stringWithFormat:@"%@",self.self.siteName];
    self.firstLabel.hidden = resultModel.first > 0;
}

- (IBAction)okButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(orderInfoView:didClickOKButton:)]) {
        [self.delegate orderInfoView:self didClickOKButton:sender];
    }
}

- (IBAction)naviButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(orderInfoView:didClickNaviButton:withReturnModel:)]) {
        [self.delegate orderInfoView:self didClickNaviButton:sender withReturnModel:self.resultModel];
    }
}

- (IBAction)closeButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(orderInfoView:didClickCloseButton:)]) {
        [self.delegate orderInfoView:self didClickCloseButton:sender];
    }
}


-(void)setRsid:(NSInteger)rsid
{
    _rsid = rsid;
}

@end

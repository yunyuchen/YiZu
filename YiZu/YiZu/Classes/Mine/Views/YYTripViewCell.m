//
//  YYTripViewCell.m
//  YiZu
//
//  Created by yunyuchen on 2017/10/16.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "YYTripViewCell.h"

@interface YYTripViewCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *startNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *endNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *keepTimeLabel;

@end

@implementation YYTripViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.layer.cornerRadius = 6;
    self.bgView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(YYDriveHisModel *)model
{
    _model = model;
    
    self.startNameLabel.text = model.sname;
    self.endNameLabel.text = model.rname;
    self.keepTimeLabel.text = [NSString stringWithFormat:@"行驶时间：%ld小时%ld分",model.keep / 60 ,model.keep % 60];
    
}

@end

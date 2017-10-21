//
//  YYConsumeRecordViewCell.m
//  YiZu
//
//  Created by yunyuchen on 2017/10/16.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "YYConsumeRecordViewCell.h"

@interface YYConsumeRecordViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation YYConsumeRecordViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(YYRecordModel *)model
{
    _model = model;
    
    self.titleLabel.text = model.des;
    self.timeLabel.text = model.ctime;
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f 元"];
}

@end

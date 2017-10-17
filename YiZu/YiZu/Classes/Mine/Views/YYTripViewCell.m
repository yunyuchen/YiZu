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

@end

//
//  YYMessageViewCell.m
//  YiZu
//
//  Created by yunyuchen on 2017/10/16.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "YYMessageViewCell.h"

@interface YYMessageViewCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation YYMessageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.timeLabel.layer.cornerRadius = 9;
    self.timeLabel.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

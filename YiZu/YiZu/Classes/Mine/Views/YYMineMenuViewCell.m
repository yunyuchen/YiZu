//
//  YYMineMenuViewCell.m
//  YiZu
//
//  Created by yunyuchen on 2017/10/14.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "YYMineMenuViewCell.h"

@implementation YYMineMenuViewCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    
    self.menuButton.imagePosition = QMUIButtonImagePositionTop;
    self.menuButton.spacingBetweenImageAndTitle = 12;
}

@end

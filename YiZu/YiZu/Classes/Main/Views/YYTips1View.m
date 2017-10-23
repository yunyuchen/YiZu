//
//  YYTips1View.m
//  BikeRental
//
//  Created by yunyuchen on 2017/6/16.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYTips1View.h"
#import <QMUIKit.h>

@implementation YYTips1View

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


- (IBAction)closeButtonClick:(id)sender {
    [QMUIModalPresentationViewController hideAllVisibleModalPresentationViewControllerIfCan];
}

- (IBAction)feedButtonClick:(id)sender {
    if (self.feedBackBlock) {
        self.feedBackBlock();
    }
}


@end

//
//  YYTips1View.m
//  BikeRental
//
//  Created by yunyuchen on 2017/6/16.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYTips1View.h"

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


- (IBAction)returnButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(YYTips1View:didClickReturnButton:)]) {
        [self.delegate YYTips1View:self didClickReturnButton:sender];
    }
}


- (IBAction)closeButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(YYTips1View:didClickCloseButton:)]) {
        [self.delegate YYTips1View:self didClickCloseButton:sender];
    }
}

- (IBAction)feedBackButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(YYTips1View:didClickFeedBackButton:)]) {
        [self.delegate YYTips1View:self didClickFeedBackButton:sender];
    }
}


@end

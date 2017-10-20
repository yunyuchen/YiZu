//
//  YYAddressView.m
//  BikeRental
//
//  Created by yunyuchen on 2017/6/16.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYAddressView.h"
#import "UIImageView+WebCache.h"

@interface YYAddressView()

@property (weak, nonatomic) IBOutlet UIImageView *siteImageView;

@property (weak, nonatomic) IBOutlet UILabel *siteNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *siteDistanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *nearLabel;


@end

@implementation YYAddressView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
        self.nearLabel.layer.cornerRadius = 4;
        self.nearLabel.layer.borderColor = [UIColor colorWithHexString:@"#FA684D"].CGColor;
        self.nearLabel.layer.borderWidth = 1;
        self.nearLabel.layer.masksToBounds = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    return self;
}

- (IBAction)returnButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(addressView:didClickReturnButton:)]) {
        [self.delegate addressView:self didClickReturnButton:sender];
    }
}

-(void)setModel:(YYSiteModel *)model
{
    _model = model;
    
    self.siteNameLabel.text = model.name;
    self.siteDistanceLabel.text = [NSString stringWithFormat:@"%.2fKM",model.distance / 1000.0];
    [self.siteImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseURL,model.img1]] placeholderImage:[UIImage imageNamed:@"Bitmap"]];
}


@end

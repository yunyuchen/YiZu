//
//  YYChargeViewController.m
//  YiZu
//
//  Created by yunyuchen on 2017/10/16.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "YYChargeViewController.h"
#import <BEMCheckBox.h>

@interface YYChargeViewController ()

@property (weak, nonatomic) IBOutlet UIView *aliPayView;

@property (weak, nonatomic) IBOutlet UIView *wechatPayView;


@end

@implementation YYChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"充值";
    
    BEMCheckBox *aliPayCheckBox = [[BEMCheckBox alloc] initWithFrame:self.aliPayView.bounds];
    [self.aliPayView addSubview:aliPayCheckBox];
    
    BEMCheckBox *wechatPayCheckBox = [[BEMCheckBox alloc] initWithFrame:self.wechatPayView.bounds];
    [self.wechatPayView addSubview:wechatPayCheckBox];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldCustomNavigationBarTransitionIfBarHiddenable
{
    return YES;
}

-(BOOL) preferredNavigationBarHidden
{
    return NO;
}

@end

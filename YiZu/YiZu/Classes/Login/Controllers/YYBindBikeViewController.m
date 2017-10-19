//
//  YYBindBikeViewController.m
//  YiZu
//
//  Created by yunyuchen on 2017/10/16.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "YYBindBikeViewController.h"

@interface YYBindBikeViewController ()

@end

@implementation YYBindBikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"绑定车辆";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextButtonClick:(id)sender {
    QMUINavigationController *mainViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"main"];
    [UIApplication sharedApplication].keyWindow.rootViewController = mainViewController;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  YYLoginViewController.m
//  YiZu
//
//  Created by yunyuchen on 2017/10/13.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "YYLoginViewController.h"

@interface YYLoginViewController ()

@end

@implementation YYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    return YES;
}

-(void)dealloc
{
    NSLog(@"111");
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
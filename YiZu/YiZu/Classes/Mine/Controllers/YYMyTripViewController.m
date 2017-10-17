//
//  YYMyTripViewController.m
//  YiZu
//
//  Created by yunyuchen on 2017/10/16.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "YYMyTripViewController.h"
#import "YYTripViewCell.h"

@interface YYMyTripViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation YYMyTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的行程";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYTripViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trip"];
    
    return cell;
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

//
//  YYMessageViewController.m
//  YiZu
//
//  Created by yunyuchen on 2017/10/16.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "YYMessageViewController.h"
#import "YYMessageViewCell.h"

@interface YYMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YYMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息中心";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYMessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"message"];
    
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

//
//  YYMyWalletViewController.m
//  YiZu
//
//  Created by yunyuchen on 2017/10/16.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "YYMyWalletViewController.h"
#import "YYConsumeRecordViewCell.h"

@interface YYMyWalletViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation YYMyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.backButton setImage: [UIImage qmui_imageWithShape:QMUIImageShapeNavBack size:CGSizeMake(12, 20) tintColor:NavBarTintColor] forState:UIControlStateNormal];
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
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

- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYConsumeRecordViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wallet"];
    
    return cell;
}

@end

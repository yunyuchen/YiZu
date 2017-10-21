//
//  YYMyWalletViewController.m
//  YiZu
//
//  Created by yunyuchen on 2017/10/16.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "YYMyWalletViewController.h"
#import "YYConsumeRecordViewCell.h"
#import "YYRecordModel.h"
#import "YYBaseRequest.h"
#import "YYUserModel.h"

@interface YYMyWalletViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *sesameStateLabel;

@property (nonatomic,strong) NSMutableArray<YYRecordModel *> *models;

@property (nonatomic,strong) YYUserModel *model;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@end

@implementation YYMyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.backButton setImage: [UIImage qmui_imageWithShape:QMUIImageShapeNavBack size:CGSizeMake(12, 20) tintColor:NavBarTintColor] forState:UIControlStateNormal];
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
    [self showEmptyViewWithLoading];

    [self getUserInfo];
    
    [self requestRecord];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getUserInfo
{
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kUserstateAPI];
    
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        [self hideEmptyView];
        if (success) {
            weakSelf.model = [YYUserModel modelWithDictionary:response];
            weakSelf.balanceLabel.text = [NSString stringWithFormat:@"%.2f",weakSelf.model.money];
            if (weakSelf.model.zmstate == 0) {
                weakSelf.sesameStateLabel.text = @"未通过芝麻信用认证";
            }else{
                weakSelf.sesameStateLabel.text = @"成功认证芝麻信用";
            }
        }
    } error:^(NSError *error) {
        
    }];
}


-(void) requestRecord
{
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kAcclogAPI];
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
         [self hideEmptyView];
        if (success) {
            weakSelf.models = [YYRecordModel modelArrayWithDictArray:response];
            
            [weakSelf.tableView reloadData];
        }
    } error:^(NSError *error) {
        
    }];
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYConsumeRecordViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wallet"];
    cell.model = self.models[indexPath.row];
    return cell;
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

@end

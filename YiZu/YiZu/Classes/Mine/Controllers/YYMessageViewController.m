//
//  YYMessageViewController.m
//  YiZu
//
//  Created by yunyuchen on 2017/10/16.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "YYMessageViewController.h"
#import "YYMessageViewCell.h"
#import "YYBaseRequest.h"
#import "YYMsgModel.h"


@interface YYMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray<YYMsgModel *> *models;

@end

@implementation YYMessageViewController

- (NSArray<YYMsgModel *> *)models
{
    if (_models == nil) {
        _models = [NSArray array];
    }
    return _models;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息中心";
    
    [self requestMessages];
    // Do any additional setup after loading the view.
}

#pragma mark - 获取消息
- (void) requestMessages
{
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kPushMsgAPI];
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weakSelf.models = [YYMsgModel modelArrayWithDictArray:response];
            
            [weakSelf.tableView reloadData];
        }
    } error:^(NSError *error) {
        
    }];
    
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
    return self.models.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYMessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"message"];
    cell.model = self.models[indexPath.row];
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

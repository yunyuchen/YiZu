//
//  YYSettingViewController.m
//  YiZu
//
//  Created by yunyuchen on 2017/10/14.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "YYSettingViewController.h"
#import "YYSettingViewCell.h"

@interface YYSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYSettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setting"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"用户协议";
        cell.detailTextLabel.text = @"";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"版本号";
        cell.detailTextLabel.text = @"1.0";
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)logoutButtonClick:(id)sender {
    QMUINavigationController *loginViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"login"];
    [UIApplication sharedApplication].keyWindow.rootViewController = loginViewController;
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

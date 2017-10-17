//
//  YYMineViewController.m
//  YiZu
//
//  Created by yunyuchen on 2017/10/14.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "YYMineViewController.h"
#import "YYMineMenuViewCell.h"

@interface YYMineViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation YYMineViewController

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


- (IBAction)closeButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YYMineMenuViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menuCell" forIndexPath:indexPath];

    NSArray *iconArray = @[@"trip_icon",@"wallet_icon",@"messgae_icon",@"guide_icon",@"Recommend_icon",@"lianxi_icon",@"abnormal_icon",@"setup_icon"];
    NSArray *nameArray = @[@"我的行程",@"我的钱包",@"我的消息",@"使用指南",@"邀请好友",@"联系我们",@"异常反馈",@"设置"];
    cell.menuButton.tag = indexPath.row;
    [cell.menuButton setImage:[UIImage imageNamed:iconArray[indexPath.row]] forState:UIControlStateNormal];
    [cell.menuButton setTitle:nameArray[indexPath.row] forState:UIControlStateNormal];
    [cell.menuButton addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth * 0.25, kScreenWidth * 0.25);
}

-(void) menuButtonClick:(UIButton *)sender
{
    NSArray *segues = @[@"mytrip",@"wallet",@"message",@"guide",@"",@"",@"feedback",@"setting"];
    
    if ([segues[sender.tag] isEqualToString:@""]) {
        return;
    }
    
    [self performSegueWithIdentifier:segues[sender.tag] sender:self];
}


@end

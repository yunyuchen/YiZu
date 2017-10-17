//
//  YYFeedBackController.h
//  RowRabbit
//
//  Created by 恽雨晨 on 2016/12/19.
//  Copyright © 2016年 常州云阳驱动. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYPublishBaseViewController.h"

@interface YYFeedBackController : YYPublishBaseViewController
/**
 *  取消按钮+监听方法
 */
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
- (IBAction)cancelClick:(UIButton *)sender;
/**
 *  title文字  默认分享新鲜事可在xib修改
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLB;


//背景
@property(nonatomic,strong) UIView *noteTextBackgroudView;

//备注
@property(nonatomic,strong) QMUITextView *noteTextView;

//文字个数提示label
@property(nonatomic,strong) UILabel *textNumberLabel;

//文字说明
@property(nonatomic,strong) UILabel *explainLabel;

//发布按钮
@property(nonatomic,strong) UIButton *submitBtn;

//换车点
@property (nonatomic,assign) NSInteger rsid;


@property (nonatomic,assign) CGFloat lat;

@property (nonatomic,assign) CGFloat lon;

@end

//
//  YYChargeViewController.m
//  YiZu
//
//  Created by yunyuchen on 2017/10/16.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "YYChargeViewController.h"
#import "NSNotificationCenter+Addition.h"
#import "YYCreateBlanceRequest.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import <BEMCheckBox.h>

@interface YYChargeViewController ()<BEMCheckBoxDelegate>

@property (weak, nonatomic) IBOutlet UIView *aliPayView;

@property (weak, nonatomic) IBOutlet UIView *wechatPayView;

@property (nonatomic,strong) BEMCheckBox *aliPayCheckBox;

@property(nonatomic, strong) BEMCheckBox *wechatPayCheckBox;

@property (weak, nonatomic) IBOutlet UIButton *value500Button;

@property (weak, nonatomic) IBOutlet UIButton *value300Button;

@property (weak, nonatomic) IBOutlet UIButton *value200Button;

@property (weak, nonatomic) IBOutlet UIButton *value100Button;

@property (nonatomic,strong) UIButton *selectedValueButton;

@end

@implementation YYChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.value300Button.layer.cornerRadius = 4;
    self.value300Button.layer.borderWidth = 1;
    self.value300Button.layer.borderColor = [UIColor qmui_colorWithHexString:@"#63C04A"].CGColor;
    self.value500Button.layer.cornerRadius = 4;
    self.value500Button.layer.borderWidth = 1;
    self.value500Button.layer.borderColor = [UIColor qmui_colorWithHexString:@"#63C04A"].CGColor;
    self.value200Button.layer.cornerRadius = 4;
    self.value200Button.layer.borderWidth = 1;
    self.value200Button.layer.borderColor = [UIColor qmui_colorWithHexString:@"#63C04A"].CGColor;
    self.value100Button.layer.cornerRadius = 4;
    self.value100Button.layer.borderWidth = 1;
    self.value100Button.layer.borderColor = [UIColor qmui_colorWithHexString:@"#63C04A"].CGColor;
    self.selectedValueButton = self.value500Button;
    self.title = @"充值";
    
    [NSNotificationCenter addObserver:self action:@selector(paySuccessAction:) name:kPayDesSuccessNotification];
    
    [NSNotificationCenter addObserver:self action:@selector(wechatPaySuccessAction:) name:kWeChatPayNotifacation];
    
    BEMCheckBox *aliPayCheckBox = [[BEMCheckBox alloc] initWithFrame:self.aliPayView.bounds];
    aliPayCheckBox.delegate = self;
    [aliPayCheckBox setOn:YES animated:YES];
    [self.aliPayView addSubview:aliPayCheckBox];
    self.aliPayCheckBox = aliPayCheckBox;
    
    BEMCheckBox *wechatPayCheckBox = [[BEMCheckBox alloc] initWithFrame:self.wechatPayView.bounds];
    wechatPayCheckBox.delegate = self;
    [self.wechatPayView addSubview:wechatPayCheckBox];
    self.wechatPayCheckBox = wechatPayCheckBox;
    // Do any additional setup after loading the view.
}

- (IBAction)valueButtonClick:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    self.selectedValueButton.selected = NO;
    self.selectedValueButton = sender;
    sender.selected = YES;
}


-(void) paySuccessAction:(NSNotification *)noti
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) wechatPaySuccessAction:(NSNotification *)noti
{
    NSString *strMsg = @"";
    BaseResp *resp = (BaseResp *)(noti.object);
    switch (resp.errCode) {
        case WXSuccess:
        {
            strMsg = @"支付成功！";
            QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
            
            QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
            contentView.minimumSize = CGSizeMake(300, 100);
            [tips showSucceed:strMsg hideAfterDelay:3];
            [self.navigationController popViewControllerAnimated:YES];
            
            return;
        }
        case WXErrCodeCommon: strMsg = @"普通错误类型"; break;
        case WXErrCodeUserCancel: strMsg = @"取消支付"; break;
        case WXErrCodeSentFail: strMsg = @"发送失败"; break;
        case WXErrCodeAuthDeny: strMsg = @"授权失败"; break;
        case WXErrCodeUnsupport: strMsg = @"微信不支持"; break;
        default: strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr]; break;
    }
    
    QMUITips *tips = [QMUITips createTipsToView:[UIApplication sharedApplication].keyWindow];
    
    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
    contentView.minimumSize = CGSizeMake(300, 100);
    [tips showInfo:strMsg hideAfterDelay:3];
}


- (IBAction)chargeButtonClick:(id)sender {
    YYCreateBlanceRequest *request = [[YYCreateBlanceRequest alloc] init];
    //request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,KCreatePayBalanceAPI];
    //request.price = [self.selectedButton.currentTitle floatValue];
    request.price = 1;
    if (self.aliPayCheckBox.on) {
        request.ptype = 0;
        [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
            if (success) {
                NSString *appScheme = @"rwPay";
                NSString *orderString = [NSString stringWithFormat:@"%@",response];
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                }];
            }
        } error:^(NSError *error) {
            
        }];
    }else{
        request.ptype = 1;
        [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
            if (success) {
                PayReq* req  = [[PayReq alloc] init];
                req.partnerId  = response[@"partnerid"];
                req.prepayId            = response[@"prepayid"];
                req.nonceStr            = response[@"noncestr"];
                req.timeStamp           = [response[@"timestamp"] intValue];
                req.package             = response[@"package"];
                req.sign                = response[@"sign"];
                [WXApi sendReq:req];
            }
        } error:^(NSError *error) {
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTapCheckBox:(BEMCheckBox*)checkBox;
{
    [checkBox setOn:YES animated:YES];
    if (checkBox == self.aliPayCheckBox) {
        [self.wechatPayCheckBox setOn:NO animated:YES];
    }else if (checkBox == self.wechatPayCheckBox){
        [self.aliPayCheckBox setOn:NO animated:YES];
    }
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

//
//  YYLoginViewController.m
//  YiZu
//
//  Created by yunyuchen on 2017/10/13.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "YYLoginViewController.h"
#import "YYBaseRequest.h"
#import "YYSendCodeRequest.h"
#import "NSNotificationCenter+Addition.h"
#import "YYFileCacheManager.h"
#import "YYLoginRequest.h"
#import "YYUserManager.h"
#import "NSDictionary+dealNullValue.h"

@interface YYLoginViewController ()

//手机号码
@property (weak, nonatomic) IBOutlet QMUITextField *mobileTextField;
//短信验证码
@property (weak, nonatomic) IBOutlet QMUITextField *messageCodeTextField;
//邀请码
@property (weak, nonatomic) IBOutlet QMUITextField *inviteCodeTextField;
//同意协议按钮
@property (weak, nonatomic) IBOutlet UIButton *agreementButton;
//获取验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *validateButton;
//倒计时
@property (nonatomic,assign) NSInteger time;
//定时器
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation YYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.time = 60;
}


- (BOOL)shouldCustomNavigationBarTransitionIfBarHiddenable
{
    return YES;
}

-(BOOL) preferredNavigationBarHidden
{
    return YES;
}

- (IBAction)agreementButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)loginButtonClick:(UIButton *)sender {
    if ([self.mobileTextField.text qmui_trim].length <= 0) {
        [QMUITips showWithText:@"请输入您的手机号码" inView:self.view hideAfterDelay:2];
        return;
    }
    if ([self.messageCodeTextField.text qmui_trim].length <= 0) {
        [QMUITips showWithText:@"请输入短信验证码" inView:self.view hideAfterDelay:2];
        return;
    }
    if (!self.agreementButton.selected) {
        [QMUITips showWithText:@"请同意用车服务条款协议" inView:self.view hideAfterDelay:2];
        return;
    }
    
    YYLoginRequest *request = [[YYLoginRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kLoginBytelAPI];
    request.tel = self.mobileTextField.text;
    request.code = self.messageCodeTextField.text;
    request.inviteid = self.inviteCodeTextField.text;
    [QMUITips showLoadingInView:self.view];
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        [QMUITips hideAllToastInView:self.view animated:YES];
        if (success) {
            QMUILog(@"%@",response);
            //记录用户Token
            [YYUserManager saveToken:response[@"token"]];
            
            NSDictionary *dict = [NSDictionary nullDic:response];
            //用户认证通过
            if ([dict[@"state"] integerValue] == 1) {
                QMUINavigationController *mainViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"main"];
                [UIApplication sharedApplication].keyWindow.rootViewController = mainViewController;
            }else{
                [weakSelf performSegueWithIdentifier:@"sesame" sender:weakSelf];
            }
        }else{
            [QMUITips showWithText:message inView:weakSelf.view hideAfterDelay:2];
        }
    } error:^(NSError *error) {
        [QMUITips hideAllToastInView:self.view animated:YES];
        QMUITips *tips = [QMUITips createTipsToView:self.view];
        QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
        contentView.minimumSize = CGSizeMake(200, 100);
        [tips showInfo:@"网络不给力" hideAfterDelay:2];
    }];
}



- (IBAction)validateButtonClick:(UIButton *)sender {
    if (self.mobileTextField.text.length <= 0) {
        [QMUITips showWithText:@"请输入您的手机号码" inView:self.view hideAfterDelay:2];
        return;
    }
    sender.userInteractionEnabled = NO;
    [sender setTitle:[NSString stringWithFormat:@"%ld S",(long)self.time] forState:UIControlStateNormal];
    
    YYBaseRequest *request = [YYBaseRequest nh_request];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kGetTokenAPI];
    
    QMUITips *tips = [QMUITips showLoadingInView:self.view];
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            [tips hideAnimated:YES];
            YYSendCodeRequest *sendCodeRequest = [[YYSendCodeRequest alloc] init];
            sendCodeRequest.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kSendCodeAPI];
            sendCodeRequest.tel = self.mobileTextField.text;
            sendCodeRequest.c_token = response;
            [sendCodeRequest nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
                if (success) {
                    [QMUITips showSucceed:@"短信验证码发送成功，请注意查收" inView:self.view hideAfterDelay:2];
                }else{
                    [QMUITips showError:@"验证码发送失败" inView:self.view hideAfterDelay:2];
                }
                
            }];
        }
        
    }];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeText) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    self.timer = timer;

}

//定时器改变文字
-(void) changeText
{
    self.time--;
    if (self.time < 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.time = 60;
        self.validateButton.userInteractionEnabled = YES;
        self.validateButton.titleLabel.alpha = 1;
        [self.validateButton setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        return;
    }
    [self.validateButton setTitle:[NSString stringWithFormat:@"%ld S",(long)self.time] forState:UIControlStateNormal];
    
    
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return YES;
}

@end

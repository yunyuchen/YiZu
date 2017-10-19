//
//  SesameAuthViewController.m
//  YiZu
//
//  Created by yunyuchen on 2017/10/13.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "SesameAuthViewController.h"
#import "Helper.h"
#import "YYUserauthRequest.h"

@interface SesameAuthViewController ()
//真实姓名
@property (weak, nonatomic) IBOutlet QMUITextField *realNameTextField;
//身份证号码
@property (weak, nonatomic) IBOutlet QMUITextField *idCardTextField;

@end

@implementation SesameAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmButtonClick:(id)sender {

    if (self.realNameTextField.text.length <= 0) {
        [QMUITips showWithText:@"请输入您的姓名" inView:self.view hideAfterDelay:2];
        return;
    }
    if (self.idCardTextField.text.length <= 0) {
        [QMUITips showWithText:@"请输入您的身份证" inView:self.view hideAfterDelay:2];
        return;
    }
    if ([Helper justIdentityCard:self.idCardTextField.text.qmui_trim]) {
        [QMUITips showWithText:@"请输入正确的身份证号码" inView:self.view hideAfterDelay:2];
        return;
    }
    YYUserauthRequest *request = [[YYUserauthRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kUserAuthAPI];
    request.idcard = self.idCardTextField.text.qmui_trim;
    request.name = self.realNameTextField.text.qmui_trim;
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            [weakSelf performSegueWithIdentifier:@"next" sender:weakSelf];
        }
    } error:^(NSError *error) {
        
    }];
}


- (BOOL)shouldCustomNavigationBarTransitionIfBarHiddenable
{
    return YES;
}

-(BOOL) preferredNavigationBarHidden
{
    return YES;
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{

    return YES;
}

@end

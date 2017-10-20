//
//  YYBindBikeViewController.m
//  YiZu
//
//  Created by yunyuchen on 2017/10/16.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "YYBindBikeViewController.h"
#import "YYBindBikeRequest.h"
#import "YYFileCacheManager.h"

@interface YYBindBikeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *bikeCodeTextField;

@end

@implementation YYBindBikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"绑定车辆";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextButtonClick:(id)sender {
    YYBindBikeRequest *request = [[YYBindBikeRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kBindBikeAPI];
    request.bcode = self.bikeCodeTextField.text;
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            if ([response integerValue] == 1) {
                [YYFileCacheManager saveUserData:@"1" forKey:kPassCheckKey];
                QMUINavigationController *mainViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"main"];
                [UIApplication sharedApplication].keyWindow.rootViewController = mainViewController;
            }else{
                [QMUITips showWithText:message inView:weakSelf.view hideAfterDelay:2];
            }
        }else{
            [QMUITips showWithText:message inView:weakSelf.view hideAfterDelay:2];
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
    return NO;
}

@end

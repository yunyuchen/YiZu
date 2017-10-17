//
//  YYFeedBackController.m
//  RowRabbit
//
//  Created by 恽雨晨 on 2016/12/19.
//  Copyright © 2016年 常州云阳驱动. All rights reserved.
//

#import "YYFeedBackController.h"
#import "YYBaseRequest.h"
//#import "YYFeedBackRequest.h"
#import "UIImage+Size.h"
#import <QMUIKit/QMUIKit.h>
#import <AVFoundation/AVFoundation.h>

//默认最大输入字数为  kMaxTextCount  300
#define kMaxTextCount 300

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//获取设备高度
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备宽度

@interface YYFeedBackController ()<UITextViewDelegate,UIScrollViewDelegate>{
 
    //备注文本View高度
    float noteTextHeight;
    float pickerViewHeight;
    float allViewHeight;
}


/**
 *  主视图-
 */
@property (weak, nonatomic) IBOutlet UIScrollView *mianScrollView;

@end

@implementation YYFeedBackController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"异常反馈";
    
    // Do any additional setup after loading the view from its nib.
    //收起键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _mianScrollView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight);
    [_mianScrollView setDelegate:self];
    self.showInView = _mianScrollView;
    
    [self initPickerView];
    
    [self initViews];
    
    self.maxCount = 1;
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied)
    {
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
        }];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的相机->设置->隐私->相机" preferredStyle:QMUIAlertControllerStyleAlert];
        [alertController addAction:action1];
        [alertController addAction:action2];
        [alertController showWithAnimated:YES];
        
    }
    
    UIButton *serviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [serviceButton setImage:[UIImage imageNamed:@"400电话"] forState:UIControlStateNormal];
    serviceButton.frame = CGRectMake(100, 100, 100, 30);
    serviceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:serviceButton];
    [serviceButton addTarget:self action:@selector(serviceButtonButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    serviceButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    self.pickerCollectionView.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
}

/**
 *  取消输入
 */
- (void)viewTapped{
    [self.view endEditing:YES];
}

/**
 *  初始化视图
 */
- (void)initViews{
    _noteTextBackgroudView = [[UIView alloc]init];
    _noteTextBackgroudView.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"请描述你的问题";
    label.frame = CGRectMake(15, 8, 200, 30);
    label.textColor = [UIColor colorWithHexString:@"#B3B3B3"];
    label.font = [UIFont systemFontOfSize:14];
    
    //文本输入框
    _noteTextView = [[QMUITextView alloc] init];
    _noteTextView.keyboardType = UIKeyboardTypeDefault;
    _noteTextView.placeholder = @"您的建议或意见将使我们更好的为您服务...";
    //文字样式
    [_noteTextView setFont:[UIFont fontWithName:@"Heiti SC" size:15.5]];
//    _noteTextView.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    [_noteTextView setTextColor:[UIColor blackColor]];
    _noteTextView.delegate = self;
    _noteTextView.font = [UIFont boldSystemFontOfSize:15.5];
    
    _textNumberLabel = [[UILabel alloc]init];
    _textNumberLabel.textAlignment = NSTextAlignmentRight;
    _textNumberLabel.font = [UIFont boldSystemFontOfSize:12];
    _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    _textNumberLabel.backgroundColor = [UIColor whiteColor];
    _textNumberLabel.text = [NSString stringWithFormat:@"0/%d    ",kMaxTextCount];
    
    _explainLabel = [[UILabel alloc]init];
//    _explainLabel.text = @"添加图片1张，文字备注不超过300字";
    _explainLabel.text = [NSString stringWithFormat:@"添加图片不超过1张，文字备注不超过%d字",kMaxTextCount];
    //发布按钮颜色
    _explainLabel.textColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1.0];
    _explainLabel.textAlignment = NSTextAlignmentCenter;
    _explainLabel.font = [UIFont boldSystemFontOfSize:12];
    
    //发布按钮样式->可自定义!
    _submitBtn = [[UIButton alloc]init];
    [_submitBtn setTitle:@"发送反馈" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn setBackgroundColor:[UIColor colorWithHexString:@"#59BD30"]];
    
    //圆角
    //设置圆角
    [_submitBtn.layer setCornerRadius:4.0f];
    [_submitBtn.layer setMasksToBounds:YES];
    [_submitBtn.layer setShouldRasterize:YES];
    [_submitBtn.layer setRasterizationScale:[UIScreen mainScreen].scale];
    
    [_submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_mianScrollView addSubview:label];
    [_mianScrollView addSubview:_noteTextBackgroudView];
    [_mianScrollView addSubview:_noteTextView];
    [_mianScrollView addSubview:_textNumberLabel];
    [_mianScrollView addSubview:_explainLabel];
    [_mianScrollView addSubview:_submitBtn];
    
    [self updateViewsFrame];
}

/**
 *  界面布局 frame
 */
- (void)updateViewsFrame{
    
    if (!allViewHeight) {
        allViewHeight = 0;
    }
    if (!noteTextHeight) {
        noteTextHeight = 200;
    }
    
    _noteTextBackgroudView.frame = CGRectMake(0, 40, SCREENWIDTH, noteTextHeight);
    
  
    
    //文本编辑框
    _noteTextView.frame = CGRectMake(15, 40, SCREENWIDTH - 30, noteTextHeight);
    
    //文字个数提示Label
    _textNumberLabel.frame = CGRectMake(15, _noteTextView.frame.origin.y + _noteTextView.frame.size.height - 30, SCREENWIDTH - 30, 15);
    
    
    //photoPicker
    [self updatePickerViewFrameY:_textNumberLabel.frame.origin.y + _textNumberLabel.frame.size.height];
    
    
    //说明文字
    _explainLabel.frame = CGRectMake(0, [self getPickerViewFrame].origin.y+[self getPickerViewFrame].size.height+10, SCREENWIDTH, 20);
    
    
    //发布按钮
    _submitBtn.bounds = CGRectMake(10, _explainLabel.frame.origin.y+_explainLabel.frame.size.height +30, SCREENWIDTH -20, 40);
    _submitBtn.frame = CGRectMake(10, _explainLabel.frame.origin.y+_explainLabel.frame.size.height +30, SCREENWIDTH -20, 40);
    
    
    allViewHeight = noteTextHeight + [self getPickerViewFrame].size.height + 30 + 100;
    
    _mianScrollView.contentSize = self.mianScrollView.contentSize = CGSizeMake(0,allViewHeight);
}

/**
 *  恢复原始界面布局
 */
-(void)resumeOriginalFrame{
    _noteTextBackgroudView.frame = CGRectMake(0, 0, SCREENWIDTH, noteTextHeight);
    //文本编辑框
    _noteTextView.frame = CGRectMake(15, 0, SCREENWIDTH - 30, noteTextHeight);
    //文字个数提示Label
    _textNumberLabel.frame = CGRectMake(0, _noteTextView.frame.origin.y + _noteTextView.frame.size.height-15, SCREENWIDTH-10, 15);
}

- (void)pickerViewFrameChanged{
    [self updateViewsFrame];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
     NSLog(@"当前输入框文字个数:%ld",_noteTextView.text.length);
    //当前输入字数
    _textNumberLabel.text = [NSString stringWithFormat:@"%lu/%d    ",(unsigned long)_noteTextView.text.length,kMaxTextCount];
    if (_noteTextView.text.length > kMaxTextCount) {
        _textNumberLabel.textColor = [UIColor redColor];
    }else{
        _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    
    [self textChanged];
    return YES;
}

//文本框每次输入文字都会调用  -> 更改文字个数提示框
- (void)textViewDidChangeSelection:(UITextView *)textView{

    NSLog(@"当前输入框文字个数:%ld",_noteTextView.text.length);
    //
    _textNumberLabel.text = [NSString stringWithFormat:@"%lu/%d    ",(unsigned long)_noteTextView.text.length,kMaxTextCount];
    if (_noteTextView.text.length > kMaxTextCount) {
        _textNumberLabel.textColor = [UIColor redColor];
    }
    else{
        _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
        [self textChanged];
}

/**
 *  文本高度自适应
 */
-(void)textChanged{
    
    CGRect orgRect = self.noteTextView.frame;//获取原始UITextView的frame
    
    //获取尺寸
    CGSize size = [self.noteTextView sizeThatFits:CGSizeMake(self.noteTextView.frame.size.width, MAXFLOAT)];
    
    orgRect.size.height=size.height+10;//获取自适应文本内容高度
    
    
    //如果文本框没字了恢复初始尺寸
    if (orgRect.size.height > 100) {
        noteTextHeight = orgRect.size.height;
    }else{
        noteTextHeight = 100;
    }
    
    [self updateViewsFrame];
}

/**
 *  发布按钮点击事件
 */
- (void)submitBtnClicked{
    //检查输入
    if (![self checkInput]) {
        return;
    }
    //输入正确将数据上传服务器->
    [self submitToServer];
}

#pragma maek - 检查输入
- (BOOL)checkInput{
    //文本框没字
//    if (_noteTextView.text.length == 0) {
//        NSLog(@"文本框没字");
//        //MBhudText(self.view, @"请添加记录备注", 1);
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入文字" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *actionCacel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
//        [alertController addAction:actionCacel];
//        [self presentViewController:alertController animated:YES completion:nil];
//        
//        return NO;
//    }
    
    //文本框字数超过300
    if (_noteTextView.text.length > kMaxTextCount) {
        NSLog(@"文本框字数超过300");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"超出文字限制" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCacel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:actionCacel];
        [self presentViewController:alertController animated:YES completion:nil];
        return NO;
    }
    return YES;
}

#warning 在此处上传服务器->>
#pragma mark - 上传数据到服务器前将图片转data（上传服务器用form表单：未写）
- (void)submitToServer{
    //大图数据
    NSArray *bigImageDataArray = [self getBigImageArray];
    
    //小图数组
    NSArray *smallImageArray = self.imageArray;
    
    //小图二进制数据
    NSMutableArray *smallImageDataArray = [NSMutableArray array];
    
    for (UIImage *smallImg in smallImageArray) {
        NSData *smallImgData = UIImagePNGRepresentation(smallImg);
        [smallImageDataArray addObject:smallImgData];
    }
    
    NSMutableArray *bigImageArray = [NSMutableArray array];
    
  
    
    //WEAK_REF(self);
    

//    if (self.imageArray.count <= 0) {
//        YYFeedBackRequest *request = [[YYFeedBackRequest alloc] init];
//        request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kFeedBackAPI];;
//        request.des = self.noteTextView.text;
//        request.img = @"";
//        if (self.lon > 0) {
//            request.lon = [NSString stringWithFormat:@"%f",self.lon];
//        }
//        if (self.lat > 0) {
//            request.lat = [NSString stringWithFormat:@"%f",self.lat];
//        }
//        if (self.rsid > 0) {
//            request.rsid = [NSString stringWithFormat:@"%ld",self.rsid];
//        }
//
//  
//        [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
//            [SVProgressHUD dismiss];
//            if (success) {
//                if ([message qmui_includesString:@"还车成功"]) {
//                    [QMUITips showSucceed:message inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:3.5];
//                    [weak_self.navigationController popToViewController:[self.navigationController.childViewControllers objectAtIndex:1] animated:YES];
//                    
//                }else{
//                    [QMUITips showSucceed:message inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:2.0];
//                    [weak_self.navigationController popViewControllerAnimated:YES];
//                }
//            
//            }else{
//                [QMUITips showError:message inView:self.view hideAfterDelay:2];
//            }
//        } error:^(NSError *error) {
//            [SVProgressHUD dismiss];
//            DLog(@"%@",error);
//        }];
//
//    }else{
//        
//        YYBaseRequest *uploadRequest = [[YYBaseRequest alloc] init];
//        uploadRequest.nh_url = [NSString stringWithFormat:@"%@%@?folder=feedback",kBaseURL,kUploadPhotoAPI];;
//        uploadRequest.nh_isPost = YES;
//        NSArray *uploadArray = [NSArray arrayWithObjects:[UIImage compressImage:self.getBigImageArray[0] toByte:1024 * 20], nil];
//        uploadRequest.nh_imageArray = uploadArray;
//        [uploadRequest nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
//            [SVProgressHUD dismiss];
//            if (success) {
//                YYFeedBackRequest *request = [[YYFeedBackRequest alloc] init];
//                request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kFeedBackAPI];;
//                request.des = self.noteTextView.text;
//                request.img = [NSString stringWithFormat:@"%@",response];
//                if (self.lon > 0) {
//                    request.lon = [NSString stringWithFormat:@"%f",self.lon];
//                }
//                if (self.lat > 0) {
//                    request.lat = [NSString stringWithFormat:@"%f",self.lat];
//                }
//                if (self.rsid > 0) {
//                    request.rsid =  [NSString stringWithFormat:@"%ld",self.rsid];
//                }
//                [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
//                    if (success) {
//                        
//                        if ([message qmui_includesString:@"还车成功"]) {
//                            [QMUITips showSucceed:message inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:3.5];
//                            [weak_self.navigationController popToViewController:[self.navigationController.childViewControllers objectAtIndex:1] animated:YES];
//                            
//                        }else{
//                            [QMUITips showSucceed:message inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:2.0];
//                            [weak_self.navigationController popViewControllerAnimated:YES];
//                        }
//
//                    }else{
//                        [QMUITips showError:message inView:self.view hideAfterDelay:2];
//                    }
//                }];
//                
//            }
//            
//        } error:^(NSError *error) {
//            [SVProgressHUD dismiss];
//            DLog(@"%@",error);
//        }];
//    
//    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"内存警告...");
}

- (IBAction)cancelClick:(UIButton *)sender {
    NSLog(@"取消");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionCacel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *actionGiveUpPublish = [UIAlertAction actionWithTitle:@"放弃上传" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:actionCacel];
    [alertController addAction:actionGiveUpPublish];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate
//用户向上偏移到顶端取消输入,增强用户体验
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
//    NSLog(@"偏移量 scrollView.contentOffset.y:%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < 0) {
        //[self.view endEditing:YES];
    }
    //NSLog(@"scrollViewDidScroll");
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

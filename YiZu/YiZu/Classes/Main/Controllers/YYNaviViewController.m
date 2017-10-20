//
//  YYNaviViewController.m
//  YiZu
//
//  Created by yunyuchen on 2017/10/13.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "YYNaviViewController.h"
#import "YYMySiteRequest.h"
#import "YYCreateOrderRequest.h"
#import "YYBikeSiteModel.h"
#import "YYUserModel.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface YYNaviViewController ()<MAMapViewDelegate>
//顶部View
@property (weak, nonatomic) IBOutlet UIView *topView;
//地图
@property(nonatomic, strong) MAMapView *mapView;
//用户位置
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;
//缩放View
@property (weak, nonatomic) IBOutlet UIView *zoomView;
//站点信息
@property(nonatomic, strong) NSArray<YYBikeSiteModel *> *bikeSiteModels;
//地图的点
@property (nonatomic, strong) NSMutableArray *annotations;
//中间锚点
@property (nonatomic,strong) UIImageView *pickImageView;
//上次位置
@property (nonatomic,assign) CLLocationCoordinate2D lastPostion;
//车辆编号
@property (weak, nonatomic) IBOutlet UILabel *bikeNoLabel;
//用户信息
@property(nonatomic, strong) YYUserModel *userModel;
@end

static NSString *reuseIndetifier = @"annotationReuseIndetifier";


@implementation YYNaviViewController

#pragma mark - lazyload
-(NSArray<YYBikeSiteModel *> *)bikeSiteModels
{
    if (_bikeSiteModels == nil) {
        _bikeSiteModels = [NSMutableArray array];
    }
    return _bikeSiteModels;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    [self initMap];
    
    [self checkLocationAuth];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestUserInfo];
}

- (void) requestUserInfo
{
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kUserstateAPI];
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weakSelf.userModel = [YYUserModel modelWithDictionary:response];
            weakSelf.bikeNoLabel.text = [NSString stringWithFormat:@"%ld",weakSelf.userModel.deviceid];
        }
    } error:^(NSError *error) {
        
    }];
    
}

#pragma mark - 开始用车按钮
- (IBAction)startUsingBikeButtonClick:(id)sender {
    YYCreateOrderRequest *request = [[YYCreateOrderRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kCreateOrderAPI];
    request.deviceid = self.userModel.deviceid;
    __weak __typeof(self)weakSelf = self;
    [QMUITips showLoadingInView:self.view];
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        [QMUITips hideAllToastInView:weakSelf.view animated:YES];
        if (success) {
            [weakSelf performSegueWithIdentifier:@"use" sender:weakSelf];
        }else{
            [QMUITips showWithText:message inView:weakSelf.view hideAfterDelay:2];
        }
    } error:^(NSError *error) {
        [QMUITips hideAllToastInView:weakSelf.view animated:YES];
    }];
}


#pragma mark - 地图放大、缩小、定位
- (IBAction)mapPlusButtonClick:(id)sender {
    [self.mapView setZoomLevel:self.mapView.zoomLevel + 1 animated:YES];
}

- (IBAction)mapDecreaseButtonClick:(id)sender {
   [self.mapView setZoomLevel:self.mapView.zoomLevel - 1 animated:YES];
}

- (IBAction)userLocationButtonClick:(id)sender {
    QMUILog(@"latitude = %f, longitude = %f",self.mapView.userLocation.coordinate.latitude,self.mapView.userLocation.coordinate.longitude);
   [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
    
   [self requestMySite];
}


#pragma mark - 监测系统权限
- (void) checkLocationAuth
{
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
        }];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的定位->设置->隐私->定位" preferredStyle:QMUIAlertControllerStyleAlert];
        [alertController addAction:action1];
        [alertController addAction:action2];
        [alertController showWithAnimated:YES];
    }
}

#pragma mark - 初始化UI
- (void) createUI
{
    self.topView.layer.cornerRadius = 12;
    self.topView.layer.masksToBounds = YES;
    self.topView.layer.borderColor = [UIColor colorWithHexString:@"#B3B3B3"].CGColor;
    self.topView.layer.borderWidth = 0.5;
    self.zoomView.layer.cornerRadius = 17;
    self.zoomView.layer.masksToBounds = YES;
}


# pragma mark 初始化地图
-(void) initMap
{
    [AMapServices sharedServices].apiKey = kAMapKey;
    
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    mapView.cameraDegree = 0;
    mapView.userTrackingMode = MAUserTrackingModeFollow;
    mapView.rotateCameraEnabled = NO;
    mapView.skyModelEnable = YES;
    mapView.showsCompass = NO;
    mapView.showsScale = NO;
    mapView.rotateEnabled  = NO;
    [mapView setZoomLevel:18.5 animated:YES];
    [self.view insertSubview:mapView atIndex:0];
    
    self.mapView = mapView;
    
    [self initAnnotations];
}

- (void)initAnnotations
{
    UIImageView *pickImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"zuobiao_icon_index"]];
    pickImageView.center = self.view.center;
    [self.view addSubview:pickImageView];
    [self.view bringSubviewToFront:pickImageView];
    self.pickImageView = pickImageView;
    
}

-(void) requestMySite
{
    YYMySiteRequest *request = [[YYMySiteRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kMySieteAPI];
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:self.pickImageView.center toCoordinateFromView:self.mapView];
    request.lat = coordinate.latitude;
    request.lng = coordinate.longitude;
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            QMUILog(@"YYMySiteRequest ---- %@",response);
            weakSelf.lastPostion = coordinate;
            weakSelf.bikeSiteModels = [YYBikeSiteModel modelArrayWithDictArray:response];
            [weakSelf.mapView removeAnnotations:weakSelf.annotations];
            weakSelf.annotations = [NSMutableArray array];
           
            for (int i = 0; i < weakSelf.bikeSiteModels.count; ++i)
            {
                MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
                a1.coordinate = CLLocationCoordinate2DMake(weakSelf.bikeSiteModels[i].latitude, weakSelf.bikeSiteModels[i].longitude);
                [weakSelf.annotations addObject:a1];
                
            }
           
            if (weakSelf.annotations.count > 0) {
                [weakSelf.mapView addAnnotations:self.annotations];
            }
        }else{
            [QMUITips showWithText:message inView:weakSelf.view hideAfterDelay:2];
        }
    } error:^(NSError *error) {
        
    }];
    
}


#pragma mark - mapview delegate
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.image = [UIImage imageNamed:@"myself_icon"];
        [self.mapView updateUserLocationRepresentation:pre];
        view.calloutOffset = CGPointMake(0, 0);
        view.canShowCallout = NO;
        self.userLocationAnnotationView = view;
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
        
   
    }
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (!updatingLocation && self.userLocationAnnotationView != nil)
    {
        [UIView animateWithDuration:0.1 animations:^{
            
            double degree = userLocation.heading.trueHeading;
            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
            
        }];
    }
    
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"cai_dingwei"];
        
        if ([annotation isKindOfClass:[MAUserLocation class]]){
            annotationView.image = [UIImage imageNamed:@"myself_icon"];
        }
        
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        //annotationView.selected = YES;
        return annotationView;
    }
    
    return nil;
}

-(void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction
{
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:self.pickImageView.center toCoordinateFromView:self.mapView];
    
    //1.将两个经纬度点转成投影点
    MAMapPoint point1 = MAMapPointForCoordinate(self.lastPostion);
    MAMapPoint point2 = MAMapPointForCoordinate(coordinate);
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    if (distance < 2000) {
        return;
    }
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    CGFloat currentTx = self.pickImageView.transform.ty;
    animation.duration = 0.6;
    CGFloat height = 10;
    animation.values = @[@(currentTx), @(currentTx - height),@(currentTx)];
    animation.keyTimes = @[ @(0), @(0.2),@(0.6)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.pickImageView.layer addAnimation:animation forKey:@"kViewShakerAnimationKey"];
    
    [self requestMySite];
    
}

#pragma mark - QMUINavigationBarDelegate

- (BOOL)shouldCustomNavigationBarTransitionIfBarHiddenable
{
    return YES;
}

-(BOOL) preferredNavigationBarHidden
{
    return YES;
}

@end

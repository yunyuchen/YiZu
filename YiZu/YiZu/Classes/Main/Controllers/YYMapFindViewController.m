//
//  YYMapFindViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/6/17.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYMapFindViewController.h"
#import "YYFileCacheManager.h"
#import "YYBaseRequest.h"
#import "YYMySiteRequest.h"
#import "YYBikeSiteModel.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface YYMapFindViewController ()<MAMapViewDelegate,AMapSearchDelegate>

@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (nonatomic, strong) NSMutableArray *annotations;

@property (nonatomic,strong) AMapSearchAPI *search;

@property (nonatomic,strong) UIImageView *pickImageView;

@property (weak, nonatomic) IBOutlet UIButton *gpsButton;

@property (weak, nonatomic) IBOutlet UIView *showView;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (nonatomic,strong) MAMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *soundButton;

@property (weak, nonatomic) IBOutlet UIView *zoomView;
//站点信息
@property(nonatomic, strong) NSArray<YYBikeSiteModel *> *bikeSiteModels;
//上次位置
@property (nonatomic,assign) CLLocationCoordinate2D lastPostion;

@end

@implementation YYMapFindViewController

static NSString *reuseIndetifier = @"annotationReuseIndetifier";

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
    
    self.title = @"地图寻车";
    
    [self initMap];
    
    [self requestMySite];
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    self.zoomView.layer.cornerRadius = 17;
    self.zoomView.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)soundButtonClick:(id)sender {
    
    YYBaseRequest *request = [[YYBaseRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kFindBikeAPI];
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message){
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
        animation.fromValue = [NSNumber numberWithFloat:1.0f];
        animation.toValue = [NSNumber numberWithFloat:0.5f];//这是透明度。
        animation.autoreverses = YES;
        animation.duration = 0.5;
        animation.repeatCount = 5;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [self.soundButton.layer addAnimation:animation forKey:nil];

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

- (IBAction)contractButtonClick:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"联系客服" message:[NSString stringWithFormat:@"%@",@"4007785701"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"864007785701"]]];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];

}


- (IBAction)hasFindButtonClick:(id)sender {
    //[[NSNotificationCenter defaultCenter] postNotificationName:kClickStartButtonNotifaction object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


@end


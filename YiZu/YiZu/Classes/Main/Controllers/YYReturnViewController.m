//
//  YYReturnViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/6/16.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYReturnViewController.h"
#import "YYAroundSiteRequest.h"
#import "YYReturnBikeRequest.h"
#import "YYSiteModel.h"
#import "CommonUtility.h"
#import "MANaviRoute.h"
#import "YYScrollAddressView.h"
#import "YYOrderInfoRequest.h"
#import "YYReturnResultModel.h"
#import "YYUserModel.h"
#import "YYOrderInfoView.h"
#import "YYTips1View.h"
#import "YYFileCacheManager.h"
#import "YYBikeSiteModel.h"
#import "YYFeedBackController.h"
#import "YYFileCacheManager.h"
#import "YYMySiteRequest.h"
#import "MANaviRoute.h"
#import "CommonUtility.h"
#import <QMUIKit/QMUIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface YYReturnViewController ()<MAMapViewDelegate,AMapSearchDelegate,AddressViewDelegate,OrderInfoViewDelegate>

@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;

@property (weak, nonatomic) IBOutlet UIView *topView;

//地图
@property(nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) NSMutableArray *annotations;

@property (nonatomic,strong) AMapSearchAPI *search;

@property (nonatomic,strong) UIImageView *pickImageView;

@property (nonatomic,strong) NSArray<YYSiteModel *> *models;

@property (weak, nonatomic) IBOutlet UIButton *gpsButton;

@property (nonatomic, strong) AMapRoute *route;

@property (nonatomic,strong) YYScrollAddressView *addressView;

@property (nonatomic,strong) YYReturnResultModel *resultModel;

@property (nonatomic,assign) NSInteger selectedId;

@property (nonatomic,strong) YYUserModel *userModel;

@property (nonatomic,strong) QMUIModalPresentationViewController *modalPrentViewController;
//站点信息
@property(nonatomic, strong) NSArray<YYBikeSiteModel *> *bikeSiteModels;
//上次位置
@property (nonatomic,assign) CLLocationCoordinate2D lastPostion;

/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;

@end

@implementation YYReturnViewController

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
    
    [self initAnnotations];
    
    [self requestMySite];
    
    [self checkLocationAuth];
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
//    YYTips1View *tips1View = [[YYTips1View alloc] init];
//    tips1View.delegate = self;
//    tips1View.frame = CGRectMake(0, 74, kScreenWidth, 158);
//    tips1View.hidden = YES;
//    self.tipsView = tips1View;
//    [self.view addSubview:self.tipsView];
}

- (void)initAnnotations
{
    UIImageView *pickImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"zuobiao_icon_index"]];
    pickImageView.center = self.view.center;
    [self.view addSubview:pickImageView];
    [self.view bringSubviewToFront:pickImageView];
    self.pickImageView = pickImageView;
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

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    if (![view.annotation isKindOfClass:[MAUserLocation class]]) {
        [view setSelected:NO animated:NO];
        CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
        CGFloat currentTx = view.transform.ty;
        animation.duration = 1.0;
        CGFloat height = 10;
        animation.values = @[@(currentTx), @(currentTx - height),@(currentTx)];
        animation.keyTimes = @[ @(0), @(0.6),@(1.0)];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [view.layer addAnimation:animation forKey:@"kViewShakerAnimationKey"];
    
        AMapWalkingRouteSearchRequest *navi = [[AMapWalkingRouteSearchRequest alloc] init];
        
        /* 出发点. */
        navi.origin = [AMapGeoPoint locationWithLatitude:self.mapView.userLocation.coordinate.latitude
                                               longitude:self.mapView.userLocation.coordinate.longitude];
        /* 目的地. */
        navi.destination = [AMapGeoPoint locationWithLatitude:self.bikeSiteModels[0].latitude
                                                    longitude:self.bikeSiteModels[0].longitude];
        
        [self.search AMapWalkingRouteSearch:navi];
        
        
        YYOrderInfoView *orderInfoView = [[YYOrderInfoView alloc] init];
        orderInfoView.rsid = self.bikeSiteModels[0].ID;
        orderInfoView.userModel = self.userModel;
        orderInfoView.delegate = self;
        orderInfoView.siteName = self.bikeSiteModels[0].name;
        
        YYOrderInfoRequest *request = [[YYOrderInfoRequest alloc] init];
        request.rsid = self.models[self.selectedId].ID;
        request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kOrderPriceAPI];
        __weak __typeof(self)weakSelf = self;
        [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
            if (success) {
                UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
                contentView.backgroundColor = UIColorWhite;
                contentView.layer.cornerRadius = 6;
                
                orderInfoView.resultModel = [YYReturnResultModel modelWithDictionary:response];
                QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
                modalViewController.contentView = orderInfoView;
                modalViewController.maximumContentViewWidth = kScreenWidth;
                modalViewController.animationStyle = QMUIModalPresentationAnimationStyleFade;
                weakSelf.modalPrentViewController = modalViewController;
                [modalViewController showWithAnimated:YES completion:nil];
            }else{
                if (self.bikeSiteModels.count > 0) {
                    //1.将两个经纬度点转成投影点
                    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(weakSelf.bikeSiteModels[0].latitude,weakSelf.bikeSiteModels[0].longitude));
                    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(weakSelf.mapView.userLocation.coordinate.latitude,weakSelf.mapView.userLocation.coordinate.longitude));
                    //2.计算距离
                    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
                    QMUILog(@"distance ===== %.f",distance);
                    YYTips1View *tipsView = [[YYTips1View alloc] init];
                    tipsView.distanceLabel.text = [NSString stringWithFormat:@"再骑%.0f米到达还车点",distance];
                    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
                    contentView.backgroundColor = UIColorWhite;
                    contentView.layer.cornerRadius = 6;
                    QMUIModalPresentationViewController *modalViewController = [[QMUIModalPresentationViewController alloc] init];
                    modalViewController.contentView = tipsView;
                    modalViewController.maximumContentViewWidth = kScreenWidth;
                    modalViewController.animationStyle = QMUIModalPresentationAnimationStyleFade;
                    weakSelf.modalPrentViewController = modalViewController;
                    [modalViewController showWithAnimated:YES completion:nil];
                }
                
            }
        } error:^(NSError *error) {
            
        }];
    }
    
}


/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    [self.naviRoute removeFromMapView];
    self.route = response.route;
    MANaviAnnotationType type = MANaviAnnotationTypeWalking;
    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[0] withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:self.mapView.userLocation.coordinate.latitude longitude:self.mapView.userLocation.coordinate.longitude ] endPoint:[AMapGeoPoint locationWithLatitude:self.bikeSiteModels[0].latitude longitude:self.bikeSiteModels[0].longitude]];
    [self.naviRoute addToMapView:self.mapView];
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                        edgePadding:UIEdgeInsetsMake(20, 20, 20, 20)
                           animated:YES];
}


//绘制遮盖时执行的代理方法
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        polylineRenderer.strokeImage = [UIImage imageNamed:@"arrowTexture"];
        polylineRenderer.lineWidth   = 4;
        polylineRenderer.lineDash = YES;
        polylineRenderer.strokeColor = [UIColor redColor];
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        polylineRenderer.strokeImage = [UIImage imageNamed:@"arrowTexture"];
        polylineRenderer.lineWidth = 4;
        
        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
        }
        else if (naviPolyline.type == MANaviAnnotationTypeRailway)
        {
            polylineRenderer.strokeColor = self.naviRoute.railwayColor;
        }
        else
        {
            polylineRenderer.strokeColor = self.naviRoute.routeColor;
        }
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MAMultiPolyline class]])
    {
        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];
        
        polylineRenderer.lineWidth = 10;
        polylineRenderer.strokeColors = [self.naviRoute.multiPolylineColors copy];
        polylineRenderer.gradient = YES;
        
        return polylineRenderer;
    }
    
    return nil;
    
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

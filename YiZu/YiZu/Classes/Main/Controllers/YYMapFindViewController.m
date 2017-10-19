//
//  YYMapFindViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/6/17.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYMapFindViewController.h"
#import "YYFileCacheManager.h"
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

@end

@implementation YYMapFindViewController

static NSString *reuseIndetifier = @"annotationReuseIndetifier";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"地图寻车";
    
    [self initMap];
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.zoomView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:self.zoomView.bounds.size];
//
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
//    //设置大小
//    maskLayer.frame = self.zoomView.bounds;
//    //设置图形样子
//    maskLayer.path = maskPath.CGPath;
//    self.zoomView.layer.mask = maskLayer;
    self.zoomView.layer.cornerRadius = 17;
    self.zoomView.layer.masksToBounds = YES;

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark 初始化地图
-(void) initMap
{
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.cameraDegree = 0;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.rotateCameraEnabled = NO;
    _mapView.skyModelEnable = YES;
    _mapView.showsCompass = NO;
    _mapView.showsScale = NO;
    _mapView.rotateEnabled = NO;
    [_mapView setZoomLevel:16.5 animated:YES];
    [self.view insertSubview:_mapView atIndex:0];
}



-(void) requestOrderInfo
{
//    YYBaseRequest *request = [[YYBaseRequest alloc] init];
//
//    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kOrderInfoAPI];
//    WEAK_REF(self);
//    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
//        if (success) {
//            weak_self.annotations = [NSMutableArray array];
//            weak_self.rentalModel = [YYRentalModel modelWithDictionary:response];
//
//            MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
//            a1.coordinate = CLLocationCoordinate2DMake(weak_self.rentalModel.lat, weak_self.rentalModel.lon);
//            [weak_self.annotations addObject:a1];
//            if (weak_self.annotations.count > 0) {
//
//                [weak_self.mapView addAnnotations:weak_self.annotations];
//
//            }
//            [weak_self.mapView setCenterCoordinate:a1.coordinate];
//
//
//        }
//    } error:^(NSError *error) {
//
//    }];
}




-(void) showRoute
{

}


#pragma mark - mapview delegate
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.image = [UIImage imageNamed:@"08定位02"];
        
        [self.mapView updateUserLocationRepresentation:pre];
        
        view.calloutOffset = CGPointMake(0, 0);
        view.canShowCallout = NO;
        self.userLocationAnnotationView = view;
        
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
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
        annotationView.image = [UIImage imageNamed:@"32车辆"];
        if ([annotation isKindOfClass:[MAUserLocation class]]){
            annotationView.image = [UIImage imageNamed:@"08定位02"];
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





#pragma mark - AMapSearchDelegate

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        
    }
}



- (IBAction)gpsButtonClick:(id)sender {
     [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
}

- (IBAction)soundButtonClick:(id)sender {
    
//    YYBaseRequest *request = [[YYBaseRequest alloc] init];
//    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kFindBikeAPI];
//    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message){
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
//        animation.fromValue = [NSNumber numberWithFloat:1.0f];
//        animation.toValue = [NSNumber numberWithFloat:0.5f];//这是透明度。
//        animation.autoreverses = YES;
//        animation.duration = 0.5;
//        animation.repeatCount = 5;
//        animation.removedOnCompletion = NO;
//        animation.fillMode = kCAFillModeForwards;
//        animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//        [self.soundButton.layer addAnimation:animation forKey:nil];
//
//    } error:^(NSError *error) {
//
//    }];
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


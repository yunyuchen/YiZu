//
//  YYNaviViewController.m
//  YiZu
//
//  Created by yunyuchen on 2017/10/13.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "YYNaviViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface YYNaviViewController ()<MAMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;

@property(nonatomic, strong) MAMapView *mapView;

@end

@implementation YYNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topView.layer.cornerRadius = 12;
    self.topView.layer.masksToBounds = YES;
    self.topView.layer.borderColor = [UIColor colorWithHexString:@"#B3B3B3"].CGColor;
    self.topView.layer.borderWidth = 0.5;
    // Do any additional setup after loading the view.
    
    [self initMap];
}


# pragma mark 初始化地图
-(void) initMap
{
    [AMapServices sharedServices].apiKey = kAMapKey;
    
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    mapView.delegate                    = self;
    mapView.showsUserLocation           = YES;
    mapView.cameraDegree = 0;
    mapView.userTrackingMode            = MAUserTrackingModeFollow;
    mapView.rotateCameraEnabled       = NO;
    mapView.skyModelEnable              = YES;
    mapView.showsCompass                = NO;
    mapView.showsScale                  = NO;
    mapView.rotateEnabled               = NO;
    [mapView setZoomLevel:18.5 animated:YES];
    [self.view insertSubview:mapView atIndex:0];
    
    self.mapView = mapView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldCustomNavigationBarTransitionIfBarHiddenable
{
    return YES;
}

-(BOOL) preferredNavigationBarHidden
{
    return YES;
}

@end

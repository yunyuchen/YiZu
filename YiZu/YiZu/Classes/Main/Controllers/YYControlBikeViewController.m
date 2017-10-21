//
//  YYControlBikeViewController.m
//  BikeRental
//
//  Created by yunyuchen on 2017/6/14.
//  Copyright © 2017年 xinghu. All rights reserved.
//

#import "YYControlBikeViewController.h"
#import "MZTimerLabel.h"
#import "NSString+YYExtension.h"
#import "YYOprateBikeRequest.h"
#import "YYFileCacheManager.h"
#import "YYBaseRequest.h"
//#import "YYPCenterViewController.h"
//#import "YYMapFindViewController.h"
//#import "YYReturnViewController.h"
#import "YYRentalModel.h"
#import <DateTools/DateTools.h>
#import <QMUIKit/QMUIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <zlib.h>

#define OPENOP  @"11"
#define CLOSEOP @"10"
@interface YYControlBikeViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>

//设备编号
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
//可用里程
@property (weak, nonatomic) IBOutlet UILabel *last_mileageLabek;
//计时
@property (weak, nonatomic) IBOutlet MZTimerLabel *driveTimeLabel;
//系统蓝牙管理对象
@property (nonatomic,strong) CBCentralManager *manager;
//当前连接的蓝牙设备
@property (strong,nonatomic) CBPeripheral *currPeripheral;
//当前的服务
@property (nonatomic,strong) CBCharacteristic *currCharacteristic;
//开始按钮
@property (weak, nonatomic) IBOutlet UIButton *startButton;
//蓝牙按钮
@property (weak, nonatomic) IBOutlet UIButton *bluetoothButton;

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (weak, nonatomic) IBOutlet UILabel *animatingLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startButtonWidthCons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startButtonHeightCons;

@property (nonatomic,strong) YYRentalModel *rentalModel;

@property (weak, nonatomic) IBOutlet QMUIButton *mapButton;

@property (weak, nonatomic) IBOutlet QMUIButton *soundButton;

@property (weak, nonatomic) IBOutlet UIView *middleView;

@property (weak, nonatomic) IBOutlet UILabel *bikeNameLabel;

@property (weak, nonatomic) IBOutlet UIView *bikeNoBgView;

@property (nonatomic,strong) QMUIModalPresentationViewController *modalPrentViewController;

@end

@implementation YYControlBikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
    
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:@{CBCentralManagerOptionShowPowerAlertKey:@YES}];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buttonClickAction:) name:kClickStartButtonNotifaction object:nil];
    
    //添加通知(处理从后台进来后的情况)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveBackgroundNoti) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    //UIApplicationDidBecomeActiveNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test) name:UIApplicationDidBecomeActiveNotification object:nil];
}


- (void) createUI
{
    self.mapButton.imagePosition = QMUIButtonImagePositionTop;
    self.soundButton.imagePosition = QMUIButtonImagePositionTop;
    self.mapButton.spacingBetweenImageAndTitle = 10;
    self.soundButton.spacingBetweenImageAndTitle = 10;
    self.middleView.layer.cornerRadius = 4;
    self.middleView.layer.masksToBounds = YES;
    self.bikeNoBgView.layer.cornerRadius = 12;
    self.bikeNoBgView.layer.masksToBounds = YES;
    self.deviceLabel.text = [NSString stringWithFormat:@"ID:%ld",(long)self.deviceid];
    self.last_mileageLabek.text = [NSString stringWithFormat:@"%.1f",self.last_mileage];
    self.bikeNameLabel.text = self.name;
    self.driveTimeLabel.timeFormat = @"HH mm";
    if (self.ctime != nil) {
        NSDate *startDate = [NSDate dateWithString:self.ctime formatString:@"yyyy-MM-dd HH:mm:ss"];
        NSTimeInterval time = [[NSDate date] secondsFrom:startDate];
        [self.driveTimeLabel setCountDownTime:time];
    }
    [self.driveTimeLabel start];
    
    if ([[YYFileCacheManager readUserDataForKey:kBikeStateKey] isEqualToString:@"0"] || [YYFileCacheManager readUserDataForKey:kBikeStateKey] == nil) {
        self.startButton.selected = YES;
        self.tipsLabel.text = @"已开启";
    }else{
        self.startButton.selected = NO;
        self.tipsLabel.text = @"已上锁";
    }
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.3f];
    animation.autoreverses = YES;
    animation.duration = 1;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.animatingLabel.layer addAnimation:animation forKey:nil];
    
    if (kScreenHeight <= 568) {
        self.startButtonWidthCons.constant = 150;
        self.startButtonHeightCons.constant = 150;
    }
    
}

-(void) test
{
    [self.manager scanForPeripheralsWithServices:nil options:nil];
}

-(void) buttonClickAction:(NSNotification *)noti
{
    [self startButtonClick:self.startButton];
}

-(void) receiveBackgroundNoti
{
    [self requestOrderInfo];
}

//获取订单信息
-(void) requestOrderInfo
{
    YYBaseRequest *orderRequest = [[YYBaseRequest alloc] init];
    orderRequest.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kOrderInfoAPI];
    __weak __typeof(self)weakSelf = self;
    [orderRequest nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message) {
        if (success) {
            weakSelf.rentalModel = [YYRentalModel modelWithDictionary:response];
            if (weakSelf.rentalModel.ID == 0) {
                if (weakSelf.currPeripheral != nil) {
                    [weakSelf.manager  cancelPeripheralConnection:weakSelf.currPeripheral];
                }
      
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
            weakSelf.deviceLabel.text = [NSString stringWithFormat:@"ID:%ld",(long)weakSelf.rentalModel.deviceid];
            weakSelf.last_mileageLabek.text = [NSString stringWithFormat:@"%.1f",weakSelf.rentalModel.last_mileage];
        }
    } error:^(NSError *error) {
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//视图即将显示
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.manager scanForPeripheralsWithServices:nil options:nil];
    
    [self requestOrderInfo];
}


//操作车辆op->指令信息
-(void) operateBike:(NSString *)op
{
    YYOprateBikeRequest *request = [[YYOprateBikeRequest alloc] init];
    request.nh_url = [NSString stringWithFormat:@"%@%@",kBaseURL,kOpratebikeAPI];
    request.op = op;
    QMUITips *tips = [QMUITips createTipsToView:self.view];
    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
    contentView.minimumSize = CGSizeMake(100, 100);
    [tips showLoading];
    __weak __typeof(self)weakSelf = self;
    [request nh_sendRequestWithCompletion:^(id response, BOOL success, NSString *message){
        [tips hideAnimated:YES];
        if (success) {
            if ([op isEqualToString:OPENOP]) {
                weakSelf.startButton.selected = YES;
                weakSelf.tipsLabel.textColor = [UIColor colorWithHexString:@"#339724"];
                weakSelf.tipsLabel.text = @"已开启";
                [YYFileCacheManager saveUserData:@"0" forKey:kBikeStateKey];
            }else{
                weakSelf.startButton.selected = NO;
                weakSelf.tipsLabel.text = @"已上锁";
                weakSelf.tipsLabel.textColor = [UIColor colorWithHexString:@"#404040"];
                [YYFileCacheManager saveUserData:@"1" forKey:kBikeStateKey];
            }
        }else{
            [QMUITips showError:message inView:weakSelf.view hideAfterDelay:2];
        }
    
  
    } error:^(NSError *error) {
        [tips hideAnimated:YES];
    }];
}


//一键还车按钮点击
- (IBAction)returnButtonClick:(UIButton *)sender {
    if (self.currPeripheral) {
        [self.manager  cancelPeripheralConnection:self.currPeripheral];
        self.currPeripheral = nil;
        self.currCharacteristic = nil;
    }
    [self performSegueWithIdentifier:@"returnBike" sender:self];
}


- (IBAction)bluetoothButtonClick:(id)sender {
    if (self.manager) {
        [self.manager scanForPeripheralsWithServices:nil options:nil];
    }
}

//启动按钮点击
- (IBAction)startButtonClick:(UIButton *)sender {
    if (sender.selected) {
     
        if (self.bluetoothButton.selected) {
            if (self.currPeripheral == nil || self.currCharacteristic == nil) {
                return;
            }
            sender.selected = !sender.selected;
            self.tipsLabel.text = @"已上锁";
            self.tipsLabel.textColor = [UIColor colorWithHexString:@"#404040"];
            NSString *sendStr = [NSString stringWithFormat:@"%@%@000000",@"A1",@"08"];
            sendStr = [self getStrByData:sendStr];
            sendStr = [NSString stringWithFormat:@"%@%@",@"06",sendStr];
            [YYFileCacheManager saveUserData:@"1" forKey:kBikeStateKey];
            [self.currPeripheral writeValue:[NSString convertHexStrToData:sendStr] forCharacteristic:self.currCharacteristic type:CBCharacteristicWriteWithResponse];
        }else{
            [self operateBike:CLOSEOP];
        }
       
    }else{
        if (!self.bluetoothButton.selected) {
            [self operateBike:OPENOP];
            return;
        }
        
        if (self.currPeripheral == nil || self.currCharacteristic == nil) {
            return;
        }
        sender.selected = !sender.selected;
        self.tipsLabel.textColor = [UIColor colorWithHexString:@"#339724"];
        self.tipsLabel.text = @"已开启";
        NSString *sendStr = [NSString stringWithFormat:@"%@%@000000",@"A1",@"05"];
        sendStr = [self getStrByData:sendStr];
        sendStr = [NSString stringWithFormat:@"%@%@",@"06",sendStr];
        [YYFileCacheManager saveUserData:@"0" forKey:kBikeStateKey];
        [self.currPeripheral writeValue:[NSString convertHexStrToData:sendStr] forCharacteristic:self.currCharacteristic type:CBCharacteristicWriteWithResponse];
    
    }
    
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


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.destinationViewController isKindOfClass:[YYMapFindViewController class]]) {
//        [segue.destinationViewController setValue:@(self.ID) forKey:@"rsid"];
//    }
//    if ([segue.destinationViewController isKindOfClass:[YYNavigationController class]]) {
//        YYPCenterViewController *controller = ((YYNavigationController *)segue.destinationViewController).topViewController;
//        [controller setValue:@"YES" forKey:@"used"];
//    }
}


-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    self.bluetoothButton.selected = NO;
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@">>>CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@">>>CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@">>>CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@">>>CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@">>>CBCentralManagerStatePoweredOff");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@">>>CBCentralManagerStatePoweredOn");
             [self.manager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"FF00"]] options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(YES)}];
            break;
    }
}

//扫描到设备会进入方法
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    if (self.rentalModel == nil) {
        return;
    }
    
    NSData *data =[self.rentalModel.bleid dataUsingEncoding:NSUTF8StringEncoding];
    
    uLong crc = crc32(0L, Z_NULL, 0);
    
    crc = crc32(crc, data.bytes, data.length);
    
    //防盗器加密后四字节
    NSData *resultData = [self little_intToByteWithData5:crc andLength:4];
    
    if ([peripheral.name hasPrefix:@"XYT"] && advertisementData[@"kCBAdvDataManufacturerData"] && [[NSString convertDataToHexStr:advertisementData[@"kCBAdvDataManufacturerData"]] rangeOfString:[NSString convertDataToHexStr:resultData]].length > 0){
        
        NSString *str = [NSString stringWithFormat:@"Did discover peripheral. peripheral: %@ rssi: %@, UUID:  advertisementData: %@ ", peripheral, RSSI, advertisementData];
        NSLog(@"%@",str);
        
        NSLog(@"%@",peripheral.services);
        //找到设备后停止扫描
        [self.manager stopScan];
        //找到的设备必须持有它，否则CBCentralManager中也不会保存peripheral，那么CBPeripheralDelegate中的方法也不会被调用！！
        self.currPeripheral = peripheral;
        //连接设备
        [self.manager connectPeripheral:peripheral options:nil];
    }
    
}

//连接到Peripherals-成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    //蓝牙连接
    NSLog(@">>>连接到名称为（%@）的设备-成功",peripheral.name);
    [peripheral setDelegate:self];
    //扫描外设Services，成功后会进入方法：-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    [peripheral discoverServices:nil];
    
}

//连接到Peripherals-失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@">>>连接到名称为（%@）的设备-失败,原因:%@",[peripheral name],[error localizedDescription]);
}

//Peripherals断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    //蓝牙断开
    NSLog(@">>>外设连接断开连接 %@: %@\n", [peripheral name], [error localizedDescription]);
    //[self.bluetoothButton setTitle:@" 未连接" forState:UIControlStateNormal];
    self.bluetoothButton.selected = NO;
}

//扫描到Services
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    //  NSLog(@">>>扫描到服务：%@",peripheral.services);
    if (error)
    {
        NSLog(@">>>Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        return;
    }
    
    for (CBService *service in peripheral.services) {
        NSLog(@"Services : %@",service.UUID.UUIDString);
        [peripheral discoverCharacteristics:nil forService:service];
    }
    
}

//扫描到Characteristics
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error)
    {
        NSLog(@"error Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        NSLog(@"service:%@ 的 Characteristic: %@",service.UUID,characteristic.UUID);
    }
    //获取Characteristic的值，读到数据会进入方法：-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
    for (CBCharacteristic *characteristic in service.characteristics){
        {
            [peripheral readValueForCharacteristic:characteristic];
        }
    }
    
    //搜索Characteristic的Descriptors，读到数据会进入方法：-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
    for (CBCharacteristic *characteristic in service.characteristics){
        [peripheral discoverDescriptorsForCharacteristic:characteristic];
    }
    
    
}

//获取的charateristic的值
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    //打印出characteristic的UUID和值
    //!注意，value的类型是NSData，具体开发时，会根据外设协议制定的方式去解析数据
    
    NSLog(@"characteristic uuid:%@  value:%@",characteristic.UUID,characteristic.value);
    
    if ([characteristic.UUID.UUIDString isEqualToString:@"FF01"]) {
        NSString *hexStr =  [NSString convertDataToHexStr:characteristic.value];
        if (hexStr.length >= 40) {
            self.currCharacteristic = characteristic;
            [self.currPeripheral setNotifyValue:YES forCharacteristic:self.currCharacteristic];
            //首次发送握手请求
            [self.currPeripheral writeValue:[NSString convertHexStrToData:@"03810283"] forCharacteristic:self.currCharacteristic type:CBCharacteristicWriteWithResponse];
        }
        if ([hexStr isEqualToString:@"03910191"] || [hexStr isEqualToString:@"03920193"] || [hexStr isEqualToString:@"03910192"]) {//已注册 | 注册成功
            NSDictionary *userInfo = [YYFileCacheManager readUserDataForKey:kUserInfoKey];
            //发送认证请求
            NSString *sendStr = [NSString stringWithFormat:@"83%@000000000000",[[NSString stringWithFormat:@"%@",userInfo[@"tel"]] changeToHexFromString]];
            sendStr = [self getStrByData:sendStr];
            sendStr = [NSString stringWithFormat:@"%@%@",@"13",sendStr];
            [self.currPeripheral writeValue:[NSString convertHexStrToData:sendStr] forCharacteristic:self.currCharacteristic type:CBCharacteristicWriteWithResponse];
        }
        if ([hexStr isEqualToString:@"03910293"]) {//未注册
            NSDictionary *userInfo = [YYFileCacheManager readUserDataForKey:kUserInfoKey];
            NSData *data =[self.rentalModel.bleid dataUsingEncoding:NSUTF8StringEncoding];
            uLong crc = crc32(0L, Z_NULL, 0);
            crc = crc32(crc, data.bytes, data.length);
            NSData *resultData = [self little_intToByteWithData:crc andLength:4];
            NSString *resultStr = [NSString stringWithFormat:@"%@%@%@0000",@"82",[[NSString stringWithFormat:@"%@",userInfo[@"tel"]] changeToHexFromString],[NSString convertDataToHexStr:resultData]];
            
            resultStr = [self getStrByData:resultStr];
            resultStr = [NSString stringWithFormat:@"%@%@",@"13",resultStr];
            [self.currPeripheral writeValue:[NSString convertHexStrToData:resultStr] forCharacteristic:self.currCharacteristic type:CBCharacteristicWriteWithResponse];
            
        }
        if ([hexStr isEqualToString:@"03930194"]) {//认证成功
            //更改按钮状态
            //[self.bluetoothButton setTitle:@" 已连接" forState:UIControlStateNormal];
            self.bluetoothButton.selected = YES;
        }
    }
    
}

//搜索到Characteristic的Descriptors
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    //打印出Characteristic和他的Descriptors
    NSLog(@"characteristic uuid:%@",characteristic.UUID);
    for (CBDescriptor *d in characteristic.descriptors) {
        NSLog(@"Descriptor uuid:%@",d.UUID);
    }
    
    if ([characteristic.UUID.UUIDString isEqualToString:@"FFC0"]) {
        self.currCharacteristic = characteristic;
    }
}

//获取到Descriptors的值
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error{
    //打印出DescriptorsUUID 和value
    //这个descriptor都是对于characteristic的描述，一般都是字符串，所以这里我们转换成字符串去解析
    NSLog(@"characteristic uuid:%@  value:%@",[NSString stringWithFormat:@"%@",descriptor.UUID],descriptor.value);
}

//设置通知
-(void)notifyCharacteristic:(CBPeripheral *)peripheral
             characteristic:(CBCharacteristic *)characteristic{
    //设置通知，数据通知会进入：didUpdateValueForCharacteristic方法
    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    
}

//取消通知
-(void)cancelNotifyCharacteristic:(CBPeripheral *)peripheral
                   characteristic:(CBCharacteristic *)characteristic{
    
    [peripheral setNotifyValue:NO forCharacteristic:characteristic];
}


//写数据
-(void)writeCharacteristic:(CBPeripheral *)peripheral
            characteristic:(CBCharacteristic *)characteristic
                     value:(NSData *)value{
    NSLog(@"%lu", (unsigned long)characteristic.properties);
    
    //只有 characteristic.properties 有write的权限才可以写
    if(characteristic.properties & CBCharacteristicPropertyWrite){
        /*
         最好一个type参数可以为CBCharacteristicWriteWithResponse或type:CBCharacteristicWriteWithResponse,区别是是否会有反馈
         */
        [peripheral writeValue:value forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }else{
        NSLog(@"该字段不可写！");
    }
    
    
}


- (NSData *)little_intToByteWithData1:(int)i andLength:(int)len{
    
    Byte abyte[len];
    
    if (len == 1) {
        
        abyte[0] = (Byte) (0xff & i);
        
    }else if (len ==2) {
        
        abyte[0] = (Byte) (0xff & i);
        
        abyte[1] = (Byte) ((0xff00 & i) >> 8);
        
    }else {
        
        abyte[0] = (Byte) (0xff & i);
        
        abyte[1] = (Byte) ((0xff00 & i) >> 8);
        
        abyte[2] = (Byte) ((0xff0000 & i) >> 16);
        
        abyte[3] = (Byte) ((0xff000000 & i) >> 24);
        
    }
    
    NSData *adata = [NSData dataWithBytes:abyte length:len];
    
    return adata;
    
}

- (NSData *)little_intToByteWithData5:(int)i andLength:(int)len{
    
    Byte abyte[len];
    
    if (len == 1) {
        
        abyte[0] = (Byte) (0xff & i);
        
    }else if (len ==2) {
        
        abyte[0] = (Byte) (0xff & i);
        
        abyte[1] = (Byte) ((0xff00 & i) >> 8);
        
    }else {
        
        abyte[0] = (Byte) ((0xff000000 & i) >> 24);;
        
        abyte[1] = (Byte) ((0xff0000 & i) >> 16);
        
        abyte[2] = (Byte) ((0xff00 & i) >> 8);
        
        abyte[3] = (Byte) (0xff & i);
        
    }
    
    NSData *adata = [NSData dataWithBytes:abyte length:len];
    
    return adata;
    
}


- (NSData *)little_intToByteWithData:(int)i andLength:(int)len{
    
    Byte abyte[len];
    
    if (len == 1) {
        
        abyte[0] = (Byte) (0xff & i);
        
    }else if (len ==2) {
        
        abyte[0] = (Byte) (0xff & i);
        
        abyte[1] = (Byte) ((0xff00 & i) >>8);
        
    }else {
        
        abyte[0] = (Byte) (0xff & i);
        
        abyte[1] = (Byte) ((0xff00 & i) >>8);
        
        abyte[2] = (Byte) ((0xff0000 & i) >>16);
        
        abyte[3] = (Byte) ((0xff000000 & i) >>24);
        
    }
    
    Byte nByte[len];
    
    nByte[0] = abyte[0] ^ abyte[3];
    
    nByte[1] = abyte[1] ^ abyte[2];
    
    nByte[2] = 0;
    
    nByte[3] = 0;
    
    NSData *adata = [NSData dataWithBytes:nByte length:len];
    
    return adata;
    
}

-(NSString *) getStrByData:(NSString *)orginalStr
{
    ///// 将16进制数据转化成Byte 数组
    NSString *hexString = orginalStr; //16进制字符串
    
    int sumResult = 0;
    
    int j = 0;
    
    NSUInteger length = [hexString length];
    Byte bytes[128];  ///3ds key的Byte 数组， 128位
    for(int i = 0;i < length; i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        //NSLog(@"int_ch=%d",int_ch);
        sumResult += int_ch;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    NSData *sum = [self little_intToByteWithData1:sumResult andLength:1];
    
    NSLog(@"sum = %@",sum);
    
    orginalStr = [orginalStr stringByAppendingString:[NSString convertDataToHexStr:sum]];
    
    NSLog(@"sendStr = %@",orginalStr);
    
    return orginalStr;
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

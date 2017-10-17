//
//  YYBluetoothManager.m
//  RPXK
//
//  Created by yunyuchen on 2017/9/30.
//  Copyright © 2017年 yunyuchen. All rights reserved.
//

#import "YYBluetoothManager.h"
#import "NSString+YYExtension.h"
#import <QMUIKit.h>

@interface YYBluetoothManager()<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) CBCharacteristic *characteristic;
@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, copy) YYBLEConnectPeripheralStateBlock connectStateCallback;
@property (nonatomic, copy) YYExameBluetoothStateBlock examBLECallback;

@end

@implementation YYBluetoothManager

static NSString *ServiceWriteUUIDStr = @"FFE5";
static NSString *ServiceReadUUIDStr = @"FFE0";

static NSString *CharacteristicWriteUUIDStr = @"FFE9";
static NSString *CharacteristicReadUUIDStr = @"FFE4";

static YYBluetoothManager *_instance;

+ (id)allocWithZone:(struct _NSZone *)zone
{
    //调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YYBluetoothManager alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (BOOL)hasConnectPeripheral
{
    NSArray *serviceUUIDs = @[[CBUUID UUIDWithString:ServiceWriteUUIDStr],[CBUUID UUIDWithString:ServiceReadUUIDStr]];
    NSArray *peripheralArray = [self.manager retrieveConnectedPeripheralsWithServices:serviceUUIDs];
    
    if ([peripheralArray count] > 0)
    {
        return YES;
    }
    
    return NO;
}


- (void)connectPeripheral
{
    // 扫描连接设备
    //[self stopScan];
    
    self.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:self.queue];
}

- (void)reScanPeripheral
{
    [self connectPeripheral];
}

- (void)stopScan
{
    if (self.manager)
    {
        [self.manager stopScan];
        
        // self.peripheral必须保证不为空，否则会崩溃
        if (self.peripheral)
        {
            [self.manager cancelPeripheralConnection:self.peripheral];
        }
        
        self.manager = nil;
    }
}

- (void)connectPeripheralWithStateCallback:(YYBLEConnectPeripheralStateBlock)connectStateCallback
                           examBLECallback:(YYExameBluetoothStateBlock)examCallback
{
    self.connectStateCallback = connectStateCallback;
    self.examBLECallback = examCallback;
    
    
    [self connectPeripheral];
}

-(NSData *)getSendCmdStr:(Byte[])cmd withCmdSize:(int) size
{
    int length = size + 3;
    Byte headerByte[] = {0x24};
    NSMutableData *data = [NSMutableData data];
    [data appendBytes:headerByte length:1];
    [data appendData:[self little_intToByteWithData:length andLength:1]];
    [data appendBytes:cmd length:size];
    Byte result = [self CalCheckSum2:data];
    [data appendBytes:&result length:1];
    
    return data;
}


// 获取校验和
- (Byte)CalCheckSum2:(NSData *)data{
    Byte chksum = 0;
    Byte *byte = (Byte *)[data bytes];
    for (NSUInteger i = 0; i < [data length]; i++){
        chksum = chksum ^ byte[i];
    }
    return chksum;
}

- (NSData *)little_intToByteWithData:(int)i andLength:(int)len{
    
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

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    //主设备状态改变的委托，在初始化CBCentralManager的时候会打开设备，只有当设备正确打开后才能使用
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            QMUILog(@">>>CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateResetting:
            QMUILog(@">>>CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnsupported:
            QMUILog(@">>>CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateUnauthorized:
            QMUILog(@">>>CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStatePoweredOff:
            QMUILog(@">>>CBCentralManagerStatePoweredOff 设备蓝牙开关未打开");
            //[[NSNotificationCenter defaultCenter] postNotificationName:kBluetoothDisconnectNotification object:nil];
            break;
        case CBCentralManagerStatePoweredOn:
            QMUILog(@">>>CBCentralManagerStatePoweredOn");
            [self.manager scanForPeripheralsWithServices:nil options:nil];
            break;
        default:
            break;
    }
}



- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if ([peripheral.name hasPrefix:@"RPXK"])
    {
        QMUILog(@"当扫描到设备:%@", peripheral);
        
        // 该设备未有连接
        if (peripheral.state == CBPeripheralStateDisconnected)
        {
            // 扫描到外设，把连接超时的计时器取消掉
            //[self scanPeripheralFinish];
            
            // 通过这种方式保留引用，否则peripheral会被释放掉不会有后续的回调
            self.peripheral = peripheral;
            self.peripheral.delegate = self;
            
            // 扫描到相关设备后连接设备，停止扫描以省电。
            [self.manager connectPeripheral:self.peripheral options:nil];
            [self.manager stopScan];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    //连接外设成功的委托
    QMUILog(@">>>连接设备（%@）成功",peripheral.name);
    CBUUID *writeUUID = [CBUUID UUIDWithString:ServiceWriteUUIDStr];
    CBUUID *readUUID = [CBUUID UUIDWithString:ServiceReadUUIDStr];
    NSArray *serviceUUIDs = @[writeUUID,readUUID];
    
    [peripheral discoverServices:serviceUUIDs];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    //外设连接失败的委托
    QMUILog(@">>>连接设备（%@）失败,原因:%@",[peripheral name],[error localizedDescription]);
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    //断开外设的委托
    QMUILog(@">>>外设断开连接 %@: %@\n", [peripheral name], [error localizedDescription]);
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services)
    {
        QMUILog(@"Discovering characteristics for service %@", service);
        
        CBUUID *writeUUID = [CBUUID UUIDWithString:CharacteristicWriteUUIDStr];
        CBUUID *readUUID = [CBUUID UUIDWithString:CharacteristicReadUUIDStr];
        NSArray *serviceUUIDs = @[writeUUID,readUUID];
        
        [peripheral discoverCharacteristics:serviceUUIDs forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        QMUILog(@"Discovered characteristic %@", characteristic);
        
       [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    }
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        if ([characteristic.UUID.UUIDString isEqualToString:@"FFE9"]) {
            Byte cmd[] = {0xA0,0x00,0x00,0x00,0x00,0x00,0x00};
            NSData *sendStr = [self getSendCmdStr:cmd withCmdSize:sizeof(cmd)];
            [peripheral writeValue:sendStr forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            self.characteristic = characteristic;
        }
    }
   
}


-(void)openSeat
{
    if ([self hasConnectPeripheral]) {
        Byte cmd[] = {0xA2,0x07,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
        NSData *sendStr = [self getSendCmdStr:cmd withCmdSize:sizeof(cmd)];
        [self.peripheral writeValue:sendStr forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    }
}

- (void) check
{
    if ([self hasConnectPeripheral]){
        Byte cmd[] = {0xA2,0x08,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
        NSData *sendStr = [self getSendCmdStr:cmd withCmdSize:sizeof(cmd)];
        [self.peripheral writeValue:sendStr forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        
    }
}

- (void)searchBike
{
    if ([self hasConnectPeripheral]){
        Byte cmd[] = {0xA2,0x04,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
        NSData *sendStr = [self getSendCmdStr:cmd withCmdSize:sizeof(cmd)];
        [self.peripheral writeValue:sendStr forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    }
}

- (void) openCmd
{
    if ([self hasConnectPeripheral]){
        Byte cmd[] = {0xA2,0x03,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
        NSData *sendStr = [self getSendCmdStr:cmd withCmdSize:sizeof(cmd)];
        [self.peripheral writeValue:sendStr forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    }
}

-(void)closeCmd
{
    if ([self hasConnectPeripheral]){
        Byte cmd[] = {0xA2,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
        NSData *sendStr = [self getSendCmdStr:cmd withCmdSize:sizeof(cmd)];
        [self.peripheral writeValue:sendStr forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    }
}

-(void)changeColorWithRed:(NSInteger)red Green:(NSInteger)green Blue:(NSInteger)blue
{
    if ([self hasConnectPeripheral]){
        Byte cmd[] = {0xA2,0x0C,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
        cmd[3] = (Byte)(0xff & red);
        cmd[4] = (Byte)(0xff & green);
        cmd[5] = (Byte)(0xff & blue);
        NSData *sendStr = [self getSendCmdStr:cmd withCmdSize:sizeof(cmd)];
        [self.peripheral writeValue:sendStr forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    }
    
}

-(void)changeLightDelay:(NSInteger)delay
{
    if ([self hasConnectPeripheral]){
        Byte cmd[] = {0xA2,0x0C,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
        cmd[6] = (Byte)(0xff & delay);
        NSData *sendStr = [self getSendCmdStr:cmd withCmdSize:sizeof(cmd)];
        [self.peripheral writeValue:sendStr forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    //QMUILog(@"characteristic uuid:%@  value:%@",characteristic.UUID,characteristic.value);
    NSString *module = [NSString convertDataToHexStr:[characteristic.value subdataWithRange:NSMakeRange(2, 1)]];
    //握手状态
    if ([module isEqualToString:@"50"] && [NSString convertDataToHexStr:[characteristic.value subdataWithRange:NSMakeRange(3, 1)]]) {
        QMUILog(@"🤝握手成功");
        if ([self.delegate respondsToSelector:@selector(shakeHandSuccess)]) {
            [self.delegate shakeHandSuccess];
        }
        //发送查询指令
        Byte cmd[] = {0xA1};
        NSData *sendStr = [self getSendCmdStr:cmd withCmdSize:sizeof(cmd)];
        [peripheral writeValue:sendStr forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    }
    
    //查询返回
    if ([module isEqualToString:@"51"]) {
        QMUILog(@"characteristic uuid:%@  value:%@",characteristic.UUID,characteristic.value);
    }
    
    //同步数据
    if ([module isEqualToString:@"53"]) {
        QMUILog(@"characteristic uuid:%@  value:%@",characteristic.UUID,characteristic.value);
       
        //车辆状态
        if ([[[NSString convertDataToHexStr:[characteristic.value subdataWithRange:NSMakeRange(3, 1)]] uppercaseString] isEqualToString:@"0C"]) {
            
            NSData *resultData = [characteristic.value subdataWithRange:NSMakeRange(3, 9)];
            
            CGFloat speed = [[[NSString convertDataToHexStr:[resultData subdataWithRange:NSMakeRange(4, 1)]] changeToDecimalFromHex] floatValue];
            CGFloat battery = [[[NSString convertDataToHexStr:[resultData subdataWithRange:NSMakeRange(6, 1)]] changeToDecimalFromHex] floatValue];
            if ([self.delegate respondsToSelector:@selector(updateWithSpeed:andBattery:)]) {
                [self.delegate updateWithSpeed:speed andBattery:battery];
            }
        }
      
    }
    
    if ([module isEqualToString:@"52"]) {
         QMUILog(@"characteristic uuid:%@  value:%@",characteristic.UUID,characteristic.value);
    }
    
    if (error)
    {
        QMUILog(@"Error changing notification state: %@", [error localizedDescription]);
        return;
    }
}

@end

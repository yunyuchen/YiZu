//
//  YYConstant.h
//  RowRabbitTravel
//
//  Created by yunyuchen on 2017/7/31.
//  Copyright © 2017年 xingyuntu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYConstant : NSObject

//请求成功通知
UIKIT_EXTERN NSString *const kNHRequestSuccessNotification;
//登录成功通知
UIKIT_EXTERN NSString *const kLoginSuccessNotification;
//登出成功通知
UIKIT_EXTERN NSString *const kLogoutSuccessNotification;
//支付成功的通知
UIKIT_EXTERN NSString *const kPayDesSuccessNotification;
//支付取消的通知
UIKIT_EXTERN NSString *const kPayDesCancelNotification;
//微信支付结果的通知
UIKIT_EXTERN NSString *const kWeChatPayNotifacation;
//还车成功的通知
UIKIT_EXTERN NSString *const kReturnSuccessNotification;
//跳转导航通知
UIKIT_EXTERN NSString *const kDirectNotifaction;
//站点刷新通知
UIKIT_EXTERN NSString *const kSiteRefreshNotifaction;
//地图寻车
UIKIT_EXTERN NSString *const kClickStartButtonNotifaction;
/** 基础URL*/
UIKIT_EXTERN NSString *const kBaseURL;
//注册, 暂时没用
UIKIT_EXTERN NSString *const kRegisterAPI;
//登录-手机号
UIKIT_EXTERN NSString *const kLoginBytelAPI;
//登录-密码
UIKIT_EXTERN NSString *const kLoginBypwdAPI;
//用户状态
UIKIT_EXTERN NSString *const kUserstateAPI;
//获取token
UIKIT_EXTERN NSString *const kGetTokenAPI;
//发送手机验证码
UIKIT_EXTERN NSString *const kSendCodeAPI;
//周边站点
UIKIT_EXTERN NSString *const kAroundSiteAPI;
//获取站点车辆信息
UIKIT_EXTERN NSString *const kGetBikeBysidAPI;
//创建押金付款订单
UIKIT_EXTERN NSString *const kCreatePayDepositAPI;
//用户认证
UIKIT_EXTERN NSString *const kUserAuthAPI;
//交易记录
UIKIT_EXTERN NSString *const kAcclogAPI;
//创建租车订单
UIKIT_EXTERN NSString *const kCreateOrderAPI;
//操作车辆
UIKIT_EXTERN NSString *const kOpratebikeAPI;
//租车信息
UIKIT_EXTERN NSString *const kOrderInfoAPI;
//还车
UIKIT_EXTERN NSString *const kReturnBikeAPI;
//创建支付订单
UIKIT_EXTERN NSString *const kCreatePayOrderAPI;
//订单金额
UIKIT_EXTERN NSString *const kOrderPriceAPI;
//申请退款
UIKIT_EXTERN NSString *const kRefundAPI;
//行程信息
UIKIT_EXTERN NSString *const kOrderListAPI;
//反馈信息
UIKIT_EXTERN NSString *const kFeedBackAPI;
//根据点获取电量最多的车辆
UIKIT_EXTERN NSString *const kGetYBikeBysidAPI;

UIKIT_EXTERN NSString *const kGetYBikeBysidAPI1;
//充值
UIKIT_EXTERN NSString *const KCreatePayBalanceAPI;
//声音寻车
UIKIT_EXTERN NSString *const kFindBikeAPI;
/** 上传头像API*/
UIKIT_EXTERN NSString *const kUploadPhotoAPI;
//上传文件
UIKIT_EXTERN NSString *const kuploadByFilesAPI;
//调用红包API
UIKIT_EXTERN NSString *const kActCallbackAPI;
//消息API
UIKIT_EXTERN NSString *const kPushMsgAPI;
//活动列表API
UIKIT_EXTERN NSString *const kActListAPI;
//邀请明细API
UIKIT_EXTERN NSString *const kInviteInfoAPI;
//获取车辆信息API
UIKIT_EXTERN NSString *const kScanCodeAPI;
//修改用户信息API
UIKIT_EXTERN NSString *const kSetUserInfoAPI;
//用户信息API
UIKIT_EXTERN NSString *const kUserInfoAPI;
//修改密码API
UIKIT_EXTERN NSString *const kResetPasswordAPI;
//电池信息
UIKIT_EXTERN NSString *const kBatteryInfoAPI;
//预约安装防盗器
UIKIT_EXTERN NSString *const kCreateDeviceOrderAPI;
//我的车辆
UIKIT_EXTERN NSString *const kMyBikesInfoAPI;
//添加车辆
UIKIT_EXTERN NSString *const kAddBikeAPI;
//失窃上报
UIKIT_EXTERN NSString *const kTheftReportAPI;
//上门维修
UIKIT_EXTERN NSString *const kOrderRepairAPI;
//维修列表
UIKIT_EXTERN NSString *const kRepairListAPI;
//维修详情
UIKIT_EXTERN NSString *const kRepairInfoAPI;
//预约卖车置换
UIKIT_EXTERN NSString *const kOrderDealAPI;
//二手车售卖列表
UIKIT_EXTERN NSString *const kSalesOrderListAPI;
//修改车辆
UIKIT_EXTERN NSString *const kEditBikeAPI;
//删除车辆
UIKIT_EXTERN NSString *const kDeleteBikeAPI;
//我的车辆
UIKIT_EXTERN NSString *const kMyBikesAPI;
//车辆详情
UIKIT_EXTERN NSString *const kBikeInfoAPI;
//设置主操作设备
UIKIT_EXTERN NSString *const kSetMainDeviceAPI;
//操作设备
UIKIT_EXTERN NSString *const kOperateBikeAPI;

UIKIT_EXTERN NSString *const kLocationAPI;
//GPS信息
UIKIT_EXTERN NSString *const kGpsinfoAPI;

UIKIT_EXTERN NSString *const kCheckBleAPI;
//监测手机是否注册
UIKIT_EXTERN NSString *const kCheckTelAPI;
//首页滚动页
UIKIT_EXTERN NSString *const kHomeTabAPI;
//商品列表
UIKIT_EXTERN NSString *const kProductListAPI;
//商品详情
UIKIT_EXTERN NSString *const kproductInfoAPI;
//收货地址列表
UIKIT_EXTERN NSString *const kAddressListAPI;
//提交订单
UIKIT_EXTERN NSString *const kCreateGoodsOrderAPI;
//订单列表
UIKIT_EXTERN NSString *const kOrderListByStateAPI;
//创建付款订单
UIKIT_EXTERN NSString *const kCreatePayOrder1API;
//取消订单
UIKIT_EXTERN NSString *const kCancelOrderAPI;
//订单详情
UIKIT_EXTERN NSString *const kGoodsOrderInfoAPI;
//删除订单
UIKIT_EXTERN NSString *const kDeleteOrderAPI;
//品牌列表
UIKIT_EXTERN NSString *const kBcodeAPI;
//申请保养
UIKIT_EXTERN NSString *const  kReqCareAPI;
//保养记录
UIKIT_EXTERN NSString *const kuserCareAPI;
//添加地址
UIKIT_EXTERN NSString *const kAddAddressAPI;
//设置默认地址
UIKIT_EXTERN NSString *const kSetDefaultAddAPI;
//获取默认地址
UIKIT_EXTERN NSString *const kGetDefaultAddAPI;
//删除地址
UIKIT_EXTERN NSString *const kDelAddressAPI;
//参数配置
UIKIT_EXTERN NSString *const kAppconfigAPI;
@end

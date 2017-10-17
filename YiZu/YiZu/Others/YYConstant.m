//
//  YYConstant.m
//  RowRabbitTravel
//
//  Created by yunyuchen on 2017/7/31.
//  Copyright © 2017年 xingyuntu. All rights reserved.
//

#import "YYConstant.h"

@implementation YYConstant

NSString *const kNHRequestSuccessNotification = @"kNHRequestSuccessNotification";

NSString *const kLoginSuccessNotification = @"kLoginSuccessNotification";

NSString *const kLogoutSuccessNotification = @"kLogoutSuccessNotification";

NSString *const kPayDesSuccessNotification = @"PayDesSuccessNotification";

NSString *const kPayDesCancelNotification = @"PayDesCancelNotification";

NSString *const kWeChatPayNotifacation = @"WeChatPayNotifacation";

NSString *const kReturnSuccessNotification = @"ReturnSuccessNotification";

NSString *const kDirectNotifaction = @"DirectNotifaction";

NSString *const kSiteRefreshNotifaction = @"SiteRefreshNotifaction";

NSString *const kClickStartButtonNotifaction = @"ClickStartButtonNotifaction";

NSString *const kBaseURL = @"http://zc.51xytu.com/";

NSString *const kRegisterAPI = @"open/get?module=UserService.register";

NSString *const kLoginBytelAPI = @"open/get?module=UserService.loginBytel";

NSString *const kLoginBypwdAPI = @"open/get?module=UserService.loginBypwd";

NSString *const kUserstateAPI = @"get?module=UserService.userstate";

NSString *const kGetTokenAPI = @"open/get?module=CodeService.getToken";

NSString *const kSendCodeAPI = @"open/get?module=CodeService.sendCodeByToken";

NSString *const kAroundSiteAPI = @"open/get?module=SiteService.arroundSite";

NSString *const kGetBikeBysidAPI = @"open/get?module=BikeService.getBikeBysid";

NSString *const kCreatePayDepositAPI = @"get?module=PayService.createPayDeposit";

NSString *const kUserAuthAPI = @"get?module=UserService.userauth";

NSString *const kAcclogAPI = @"get?module=UserService.acclog";

NSString *const kCreateOrderAPI = @"get?module=BikeService.createOrder";

NSString *const kOpratebikeAPI = @"get?module=BikeService.opratebike";

NSString *const kOrderInfoAPI = @"get?module=BikeService.orderInfo";

NSString *const kReturnBikeAPI = @"get?module=BikeService.returnBike";

NSString *const kCreatePayOrderAPI = @"get?module=PayService.createPayOrder";

NSString *const kOrderPriceAPI = @"get?module= BikeService.orderPrice";

NSString *const kRefundAPI = @"get?module=UserService.refund";

NSString *const kOrderListAPI = @"get?module=BikeService.orderList";

NSString *const kFeedBackAPI = @"get?module=UserService.feedback";

NSString *const kGetYBikeBysidAPI = @"open/get?module=BikeService.getYBikeByLat";

NSString *const kGetYBikeBysidAPI1 = @"open/get?module=BikeService.getYBikeBysid";

NSString *const KCreatePayBalanceAPI = @"get?module=PayService.createPayBalance";

NSString *const kFindBikeAPI = @"get?module=BikeService.findbike";

NSString *const kUploadPhotoAPI = @"upload";

NSString *const kuploadByFilesAPI = @"uploadByFiles";

NSString *const kActCallbackAPI = @"get?module=UserService.shareActCallback";

NSString *const kPushMsgAPI = @"get?module=UserService.pushmsg";

NSString *const kActListAPI = @"open/get?module=UserService.actlist";

NSString *const kInviteInfoAPI = @"get?module=UserService.inviteinfo";

NSString *const kScanCodeAPI = @"get?module=BikeService.scanCode";

NSString *const kSetUserInfoAPI = @"get?module=UserService.setUserInfo";

NSString *const kUserInfoAPI = @"get?module=UserService.userInfo";

NSString *const kResetPasswordAPI = @"open/get?module=UserService.resetPwd";

NSString *const kBatteryInfoAPI = @"get?module=DeviceService.batteryInfo";

NSString *const kCreateDeviceOrderAPI = @"get?module=DeviceService.createDeviceOrder";

NSString *const kMyBikesInfoAPI = @"get?module=DeviceService.myBikes";

NSString *const kAddBikeAPI = @"get?module=DeviceService.addBike";

NSString *const kTheftReportAPI = @"get?module=DeviceService.theftReport";

NSString *const kOrderRepairAPI = @"get?module=RepairService.orderRepair";

NSString *const kRepairListAPI = @"get?module=RepairService.repairList";

NSString *const kRepairInfoAPI = @"get?module=RepairService.repairInfo";

NSString *const kOrderDealAPI = @"get?module=DealService.orderDeal";

NSString *const kSalesOrderListAPI = @"get?module=DealService.orderList";

NSString *const kEditBikeAPI = @"get?module=DeviceService.editBike";

NSString *const kDeleteBikeAPI = @"get?module=DeviceService.delBike";

NSString *const kMyBikesAPI = @"get?module=DeviceService.myBikes";

NSString *const kBikeInfoAPI = @"get?module=DeviceService.bikeInfo";

NSString *const kSetMainDeviceAPI = @"get?module=DeviceService.setMainDevice";

NSString *const kOperateBikeAPI = @"get?module=DeviceService.opratebike";

NSString *const kLocationAPI = @"get?module=DeviceService.location";

NSString *const kGpsinfoAPI = @"get?module=DeviceService.gpsinfo";

NSString *const kCheckBleAPI = @"get?module=DeviceService.checkBle";

NSString *const kCheckTelAPI = @"open/get?module=UserService.checkTel";

NSString *const kHomeTabAPI = @"open/get?module=UserService.hometab";

NSString *const kProductListAPI = @"open/get?module=EBService.productList";

NSString *const kproductInfoAPI = @"open/get?module=EBService.productInfo";

NSString *const kAddressListAPI = @"get?module=EBService.addressList";

NSString *const kCreateGoodsOrderAPI = @"get?module=EBService.createOrder";

NSString *const kOrderListByStateAPI = @"get?module=EBService.orderListByState";

NSString *const kCreatePayOrder1API = @"get?module=EBService.createPayOrder";

NSString *const kGoodsOrderInfoAPI = @"get?module=EBService.orderInfo";

NSString *const kCancelOrderAPI = @"get?module=EBService.cancelOrder";

NSString *const kDeleteOrderAPI = @"get?module=EBService.delOrder";

NSString *const kBcodeAPI = @"get?module=DeviceService.bcode";

NSString *const kReqCareAPI = @"get?module=EBService.reqCare";

NSString *const kuserCareAPI = @"get?module=EBService.usercare";

NSString *const kAddAddressAPI = @"get?module=EBService.addAddress";

NSString *const kSetDefaultAddAPI = @"get?module=EBService.setDefaultAdd";

NSString *const kGetDefaultAddAPI = @"get?module=EBService.getDefaultAdd";

NSString *const kDelAddressAPI = @"get?module=EBService.delAddress";

NSString *const kAppconfigAPI = @"open/get?module=UserService.appconfig";
@end

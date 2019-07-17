//
//  BNPayToolConfig.h
//  WeiHouBao
//
//  Created by hsf on 2017/11/1.
//  Copyright © 2017年 WeiHouKeJi. All rights reserved.
//

#ifndef BNPayToolConfig_h
#define BNPayToolConfig_h

#import "Globle_Key.h"

#pragma mark- -阿里支付

#import <AlipaySDK/AlipaySDK.h> //支付宝SDK
#import "BNPayTool.h"     //支付宝调起支付类

#import "APAuthInfo.h"
#import "APRSASigner.h"          //支付宝签名类
#import "APOrderInfo.h"               //订单模型


//支付宝私钥（用户自主生成，使用pkcs8格式的私钥）
#define kPay_PrivateKey_Ali  @""

//应用注册scheme,在AliSDKDemo-Info.plist定义URL types
#define kPay_URLScheme_Ali   @"com.payAli.iOSClient"

/**
 -----------------------------------
 支付宝支付接口
 -----------------------------------
 */

//#define kPay_tradeUrl_Ali    @"alipay.trade.app.pay"



/*================================================================================================================================*/

#pragma mark - -微信支付

#import "WXApiRequestHandler.h"
#import "WXApiManager.h"

/**
 注意:支付单位为分

*/


#define kWX_noncestr    @"noncestr"
#define kWX_package     @"package"
#define kWX_partnerid   @"partnerid"
#define kWX_prepayid    @"prepayid"
#define kWX_sign        @"sign"
#define kWX_timestamp   @"timestamp"


#define kWX_NOTI_PaySucess  @"kWX_NOTI_PaySucess"


#endif /* BN_PayToolConfig_h */

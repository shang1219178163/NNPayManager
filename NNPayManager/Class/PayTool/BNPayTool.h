//
//  BNPayTool.h
//  WeiHouBao
//
//  Created by hsf on 2017/11/1.
//  Copyright © 2017年 WeiHouKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WXApiObject.h"

#import "BNPayToolConfig.h"

@class BNPayModel;

///**
// 支付回调(如果多个支付共用一个调起方法,可用此代码块区分返回值,不过不建议这样做)
// 
// @param objc 回调实体对象
// @param outTradeNo 支付宝返回订单号
// @param payType 支付方式:0苹果,1微信,1支付宝
// */
//typedef void(^BlockPay)(id objc,id outTradeNo,NSString * payType);


/**
 支付结果回调

 @param objc 回调实体对象,微信BaseResp对象,支付宝resultDic
 @param outTradeNo 微信不返回订单号为nil,支付宝为resultDic重解析的订单号
 */
typedef void(^BlockPay)(id objc,id outTradeNo);


@interface BNPayTool : NSObject

@property (nonatomic, copy) BlockPay blockPay;
@property (nonatomic, strong) BNPayModel *payModel;//微信支付传值,其他支付方式需要其他参数可扩展

/**
 *  获取单例
 */
+ (instancetype)shared;

/**
 微信注册
 */
+ (void)registerPayWXAppID:(NSString *)appID;

/**
 *  发起支付宝支付请求
 */
- (void)payALIParam:(NSString *)string handler:(BlockPay)handler;

/**
 *  发起微信支付请求
 */
- (void)payWXParam:(NSDictionary *)dict handler:(BlockPay)handler;

/**
 *  回调入口
 */
- (BOOL)handlePaymentResultOpenURL:(NSURL *)url;

/**
 支付完成需要把返回的outtradeID给解析出来，给服务器二次确认
 */
+ (NSString *)getOut_trade_noWithAliDict:(NSDictionary *)resultDic;

/**
 ALI官方方法,仅用于调试
 */
- (void)doAPPayAli;

@end

//微信支付传值数据模型,需要额外的属性均可在此模型添加
@interface BNPayModel : PayReq

@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *out_trade_no;

@end

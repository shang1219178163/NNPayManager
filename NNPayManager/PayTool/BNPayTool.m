//
//  BNPayTool.m
//  WeiHouBao
//
//  Created by hsf on 2017/11/1.
//  Copyright © 2017年 WeiHouKeJi. All rights reserved.
//

#import "BNPayTool.h"

#import "NSString+Helper.h"
#import "NSDictionary+Helper.h"

@interface BNPayTool()<WXApiDelegate>

@end

@implementation BNPayTool

+(BNPayTool *)shared{
    static BNPayTool * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[BNPayTool alloc]init];
        
    });
    return _instance;
}

/**
 微信支付注册

 */
+ (void)registerPayWXAppID:(NSString *)appID{
    [WXApi registerApp:appID];
    
}

/**
 *  发起支付宝支付请求
 */
- (void)payALIParam:(NSString *)string handler:(BlockPay)handler{
    self.blockPay = handler;
    
//    NSString * bodyString = [signedString stringByRemovingPercentEncoding];
//    DDLog(@"_______%@",bodyString);
    
    [AlipaySDK.defaultService payOrder:string fromScheme:kPay_URLScheme_Ali callback:^(NSDictionary *resultDic) {
        //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,跟callback一样的逻辑】
        [self hanleAilPayCallBackResultDic:resultDic];

    }];
}

/**
 *  发起微信支付请求
 */
- (void)payWXParam:(NSDictionary *)dict handler:(BlockPay)handler{
    self.blockPay = handler;
    
    [[self class] registerPayWXAppID:kAppID_WX];
    if(![WXApi isWXAppInstalled]) {
        [UIAlertController showAletTitle:@"" msg:@"未安装微信!" handler:nil];
        return ;
    }
    
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    
    req.nonceStr            = dict [kWX_noncestr];
    req.package             = dict [kWX_package];
    req.partnerId           = dict [kWX_partnerid];
    req.prepayId            = dict [kWX_prepayid];
    req.sign                = dict [kWX_sign];
    req.timeStamp           = [dict [kWX_timestamp] intValue];
//    [req setValuesForKeysWithDictionary:dict];
    
    if (![WXApi sendReq:req]) {
        DDLog(@"---------------------微信支付调用失败---------------------");
    }
    //日志输出
    DDLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign);
}
/**
 *  回调入口
 */
- (BOOL)handlePayResultOpenURL:(NSURL *)url{
//    DDLog(@"url____\n%@",url);

    if ([url.host isEqualToString:@"safepay"]) {
        [AlipaySDK.defaultService processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,跟callback一样的逻辑】
            [self hanleAilPayCallBackResultDic:resultDic];
            
        }];
    }
    
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        [AlipaySDK.defaultService processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,跟callback一样的逻辑】
            [self hanleAilPayCallBackResultDic:resultDic];
            
        }];
    }
    return [WXApi handleOpenURL:url delegate:self];
    
}


/**
 ALI回调数据处理

 @param resultDic 回调实体数据
 */
- (void)hanleAilPayCallBackResultDic:(NSDictionary *)resultDic{
//    DDLog(@"resultDic = %@",resultDic);

    NSString *result = resultDic[@"result"];
    NSString *resultStatus = resultDic[@"resultStatus"];
    
    //9000 订单支付成功
    // 支付完成需要把返回的outtradeID给解析出来，给服务器二次确认
    if ([resultStatus isEqualToString:@"9000"]){
        NSString * jsonStr = [result stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        NSDictionary * dict = [jsonStr dictValue];
        //\"out_trade_no\":\"15154064685511\"
        NSString * out_trade_no = dict[@"alipay_trade_app_pay_response"][@"out_trade_no"];

        self.blockPay(resultDic, out_trade_no);
//        [[NSNotificationCenter defaultCenter] postNotificationName:kWX_NOTI_PaySucess object:nil];
          //代码块回调方法里会调用接口,不必重复使用通知
    }
    else{
        //8000 正在处理中 4000  订单支付失败 6001 用户中途取消/重复操作取消 6002  网络连接出错
        self.blockPay(resultDic, nil);

    }
}

+ (NSString *)getOut_trade_noWithAliDict:(NSDictionary *)resultDic{
    
    NSString *result = resultDic[@"result"];
    NSString *resultStatus = resultDic[@"resultStatus"];
    //9000 订单支付成功
    if ([resultStatus isEqualToString:@"9000"]){
        //返回json字符串
        NSString * jsonStr = [result stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        NSDictionary * dict = [jsonStr dictValue];
        //\"out_trade_no\":\"15154064685511\"
        NSString * out_trade_no = dict[@"alipay_trade_app_pay_response"][@"out_trade_no"];
        return out_trade_no;
    }
    else{
        //8000 正在处理中 4000  订单支付失败 6001 用户中途取消/重复操作取消 6002  网络连接出错
        return nil;
    }
    return nil;
}


/**
 微信回调代理

 @param resp 回调实体数据
 */
- (void)onResp:(BaseResp *)resp{
    self.blockPay(resp, nil);

//    if([resp isKindOfClass:[PayResp class]]){
    
//        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
//        //        NSString *strTitle = @"支付结果";
//        switch (resp.errCode) {
//            case WXSuccess:
//            {
//                strMsg = @"支付结果：成功！";
//                //发出通知 从微信回调回来之后,发一个通知,让请求支付的页面接收消息,并且展示出来,或者进行一些自定义的展示或者跳转
////                [[NSNotificationCenter defaultCenter] postNotificationName:kWX_NOTI_PaySucess object:nil];
//                //代码块回调方法里会调用接口,不必重复使用通知
//            }
//                break;
//            case WXErrCodeUserCancel:
//                strMsg = @"支付结果：用户点击取消！";
//                
//                break;
//            case WXErrCodeSentFail:
//                strMsg = @"支付结果：发送失败！";
//                
//                break;
//            case WXErrCodeAuthDeny:
//                strMsg = @"支付结果：授权失败！";
//                
//                break;
//                
//            default:
//                strMsg = @"支付结果：微信不支持！";
//                break;
//        }
//    }
}

#pragma mark - - 官方方法
- (void)doAPPayAli{
    // 重要说明
    // 这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    // 真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    // 防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = kAPPID_Ali;
    
    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    NSString *rsa2PrivateKey = kPay_PrivateKey_Ali;
    NSString *rsaPrivateKey = @"";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"缺少appId或者私钥,请检查参数设置"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"知道了"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action){
                                                    
                                                }]];
        UIWindow * keyWindow = UIApplication.sharedApplication.keyWindow;
        [keyWindow.rootViewController presentViewController:alert animated:YES completion:^{ }];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    APOrderInfo* order = [APOrderInfo new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"UTF-8";
    order.format = @"json";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [APBizContent new];
    order.biz_content.body = @"微猴运宝";
    order.biz_content.subject = @"微猴运宝支付";
    order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格
    
    order.notify_url = @"http://www.weihouyunbao.cn/payment/alipay/notify.php";

    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    APRSASigner* signer = [[APRSASigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = kPay_URLScheme_Ali;
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        DDLog(@"orderString=====%@",[orderString stringByRemovingPercentEncoding]);
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            NSString *strMsg = [NSString stringWithFormat:@"resultStatus:%@", resultDic[@"resultStatus"]];
            switch ([resultDic[@"resultStatus"] integerValue]) {
                case 9000:
                    strMsg = @"支付结果：支付成功！";
                    break;
                case 8000:
                    strMsg = @"支付结果：正在处理中！";
                    break;
                case 6002:
                    strMsg = @"支付结果：网络连接出错! ";
                    break;
                case 6001:
                    strMsg = @"支付结果：用户中途取消/重复操作取消! ";
                    break;
                case 4000:
                    strMsg = @"支付结果：订单支付失败！";
                    break;
                default:
                    break;
            }
            [UIAlertController showAletTitle:@"" msg:strMsg handler:nil];
        }];
    }
}

#pragma mark --产生随机订单号
- (NSString *)generateTradeNO{
    static int kNumber = 15;
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

#pragma mark -lazy

-(BNPayModel *)payModel{
    if (!_payModel) {
        _payModel = [[BNPayModel alloc]init];
    }
    return _payModel;
}

@end

@implementation BNPayModel


@end

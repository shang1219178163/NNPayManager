//
//  WHKNetMoneyMsgSignModel.h
//  BNPayTool
//
//  Created by hsf on 2018/2/11.
//  Copyright © 2018年 BIN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXSignModel : NSObject

@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *noncestr;
@property (nonatomic, copy) NSString *out_trade_no;

@property (nonatomic, copy) NSString *package;
@property (nonatomic, copy) NSString *prepayid;
@property (nonatomic, copy) NSString *partnerid;

@property (nonatomic, copy) NSString *sign;

@property (nonatomic, assign) NSInteger timestamp;

@end

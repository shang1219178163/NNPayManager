//
//  MainViewController.m
//  ChildViewControllers
//
//  Created by hsf on 2017/10/28.
//  Copyright © 2017年 BIN. All rights reserved.
//

#import "MainViewController.h"

#import "BNPayToolConfig.h"
#import "BNWXSignModel.h"

#import "NextViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) NSMutableArray * titleMarr;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"Main(Pay)";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"银行卡" style:UIBarButtonItemStyleDone target:self action:@selector(handleActionSender:)];
    
    /*调用前先配置根据官方文档配置schem*/
    /*
    //发起支付->接口返回响应模型数据(支付宝为签名字符串,微信为json模型数据)
    //阿里
    WHKNetMoneyMsgSignModel * signModel = nil;
    [self handlePayALI:signModel];
    //微信(需要检查参数是否为空)
    if ([self isParamsRight:signModel]) {
        [self handlePayWX:signModel];
        
    }
    */
}

- (void)handleActionSender:(UIBarButtonItem *)sender{
    
    
}

- (void)handlePayALI:(BNWXSignModel *)signModel{

    NSString * signedString = signModel.sign;
    [BNPayTool.shared payALIParam:signedString handler:^(id objc,id outTradeNo) {
        DDLog(@"reslut = %@",objc);
        
        //支付结果以后台为准,无论本地返回成功失败
        //        [self requestWithInterfaceRank:@"1" pageIndex:0];
        
        
    }];
}


- (void)handlePayWX:(BNWXSignModel *)signModel{
    
    NSMutableDictionary * mdict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [mdict setSafeObjct:signModel.noncestr forKey:kWX_noncestr];
    [mdict setSafeObjct:signModel.package forKey:kWX_package];
    [mdict setSafeObjct:signModel.partnerid forKey:kWX_partnerid];
    [mdict setSafeObjct:signModel.prepayid forKey:kWX_prepayid];
    [mdict setSafeObjct:signModel.sign forKey:kWX_sign];
    [mdict setSafeObjct:@(signModel.timestamp) forKey:kWX_timestamp];
    
    [mdict setSafeObjct:signModel.appid forKey:@"appid"];
    
    [BNPayTool.shared payWXParam:mdict handler:^(id objc,id outTradeNo) {
        DDLog(@"reslut = %@",objc);
        //支付结果以后台为准,无论本地返回成功失败
//        [self requestWithInterfaceRank:@"1" pageIndex:0];
        
    }];
    
}

- (BOOL)isParamsRight:(BNWXSignModel *)signModel{
    if (![signModel.noncestr validObject]) {
        return NO;
    }
    
    if (![signModel.package validObject]) {
        return NO;
    }
    
    if (![signModel.partnerid validObject]) {
        return NO;
    }
    
    if (![signModel.prepayid validObject]) {
        return NO;
    }
    
    if (![signModel.sign validObject]) {
        return NO;
    }
    
    if (![[@(signModel.timestamp) stringValue] validObject]) {
        return NO;
    }
    return YES;
}


- (void)handleActionBtn:(UIBarButtonItem *)sender{
    NextViewController *viewController = [[NextViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

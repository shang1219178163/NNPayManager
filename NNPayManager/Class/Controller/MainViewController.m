//
//  MainViewController.m
//  ChildViewControllers
//
//  Created by hsf on 2017/10/28.
//  Copyright © 2017年 BIN. All rights reserved.
//

#import "MainViewController.h"

#import "NNPayManager.h"

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
    
}

- (void)handleActionSender:(UIBarButtonItem *)sender{
    NextViewController *viewController = [[NextViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (void)jumpAliApp:(NSDictionary *)jsonData orderno:(NSString *)orderno{
    NSString *tn = jsonData[@"tn"];
    NSData *data = [tn dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
        [UIAlertController showAletTitle:@"提示" msg:error.description handler:nil];
        return ;
    }
    
    if (![dic.allKeys containsObject:@"sign"]) {
        [UIAlertController showAletTitle:@"提示" msg:@"签名错误!" handler:nil];
        return ;
    }
    
    [NNPayManager.shared payALI:dic[@"sign"] orderno:orderno handler:^(id  _Nonnull obj, NSString * _Nonnull orderno, BOOL success) {
        if (!orderno) {
            [UIAlertController showAletTitle:@"提示" msg:@"订单号不能为空!" handler:nil];
            return ;
        }
//        DDLog(@"reslut = %@", obj);
        [self requestForOrderStatus:orderno obj: obj];
    }];
}

- (void)jumpWXApp:(NSDictionary *)jsonData orderno:(NSString *)orderno{
    NSString *tn = jsonData[@"tn"];
    NSData *data = [tn dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
        [UIAlertController showAletTitle:@"提示" msg:error.description handler:nil];
        return ;
    }
    
    [NNPayManager.shared payWX:dic orderno:orderno handler:^(id  _Nonnull obj, NSString * _Nonnull orderno, BOOL success) {
//        DDLog(obj);
        if (!orderno) {
            [UIAlertController showAletTitle:@"提示" msg:@"订单号不能为空!" handler:nil];
            return ;
        }
        [self requestForOrderStatus:orderno obj: obj];
    }];
}

- (void)requestForOrderStatus:(NSString *)outTradeNo obj:(id)obj{

}

- (BOOL)isParamsRight:(NSDictionary *)dic{
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

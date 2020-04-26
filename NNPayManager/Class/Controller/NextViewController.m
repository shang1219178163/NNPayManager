
//
//  NextViewController.m
//  ChildViewControllers
//
//  Created by hsf on 2018/1/16.
//  Copyright © 2018年 BIN. All rights reserved.
//

#import "NextViewController.h"

@interface NextViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSArray *imageArr;

@end

@implementation NextViewController

-(NSArray *)imageArr{
    if (!_imageArr) {
        _imageArr = @[@"img_orderLocation_N.png",@"img_orderLocation_H.png"];
        
    }
    return _imageArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Next";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStyleDone target:self action:@selector(handleActionBtn:)];
}

- (void)handleActionBtn:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [UIView transitionWithView:self.imageView duration:2.0f options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
//        self.imageView.tag++;
//        UIImage *image = (self.imageView.tag % 2 == 0) ? [UIImage imageNamed:[self.imageArr firstObject]] : [UIImage imageNamed:[self.imageArr lastObject]];
//        [self.imageView setImage:image];
//
//    } completion:^(BOOL finished) {
//        NSLog(@"图像翻转完成");
//    }];
    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI_2);
    
}




@end

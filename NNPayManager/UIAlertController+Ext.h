//
//  UIAlertController+Ext.h
//  NNPayManager
//
//  Created by Bin Shang on 2020/4/26.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (Ext)

+ (instancetype)createAlertTitle:(NSString *_Nullable)title msg:(NSString *_Nullable)msg placeholders:(NSArray *_Nullable)placeholders actionTitles:(NSArray *_Nullable)actionTitles handler:(void(^_Nullable)(UIAlertController * alertVC, UIAlertAction * action))handler;

+ (instancetype)showAlertTitle:(NSString * _Nullable)title msg:(NSString *_Nullable)msg placeholders:(NSArray *_Nullable)placeholders actionTitles:(NSArray *_Nullable)actionTitles handler:(void(^_Nullable)(UIAlertController * alertVC, UIAlertAction * action))handler;

+ (instancetype)createSheetTitle:(NSString *_Nullable)title msg:(NSString *_Nullable)msg actionTitles:(NSArray *_Nullable)actionTitles handler:(void(^_Nullable)(UIAlertController * alertVC, UIAlertAction * action))handler;

+ (instancetype)showSheetTitle:(NSString *_Nullable)title msg:(NSString *_Nullable)msg actionTitles:(NSArray *_Nullable)actionTitles handler:(void(^_Nullable)(UIAlertController * alertVC, UIAlertAction * action))handler;

+ (instancetype)showAletTitle:(NSString *_Nullable)title msg:(NSString *_Nullable)msg handler:(void(^ _Nullable)(void))handler;

@end

NS_ASSUME_NONNULL_END

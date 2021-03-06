//
//  AppDelegate.m
//  NNPayManager
//
//  Created by Bin Shang on 2019/7/17.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

#import "AppDelegate.h"

#import "NNPayManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //    [UIApplication setupNavigationbar];
    
    UIViewController * mainVC = [[NSClassFromString(@"MainViewController") alloc]init];
    UINavigationController * mainNav = [[UINavigationController alloc]initWithRootViewController:mainVC];
    self.window.rootViewController = mainNav;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark -

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    //处理支付结果
    [NNPayManager.shared handlePaymentResultOpenURL:url];
    return YES;
}
#else
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    //处理支付结果
    [NNPayManager.shared handlePayResultOpenURL:url];
    return YES;
}
#endif

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *webpageURL = userActivity.webpageURL;
        NSString *host = webpageURL.host;
        if ([host isEqualToString:@"apple..com"]) {
            //进行我们需要的处理
        }
        else {
            [UIApplication.sharedApplication openURL:webpageURL];
        }
    }
    return true;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

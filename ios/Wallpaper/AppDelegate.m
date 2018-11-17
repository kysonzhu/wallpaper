//
//  AppDelegate.m
//  WallWrapper ( https://github.com/kysonzhu/wallpaper.git )
//
//  Created by zhujinhui on 14-12-9.
//  Copyright (c) 2014年 zhujinhui( http://kyson.cn ). All rights reserved.
//

#import "AppDelegate.h"
#import "WPHomeViewController.h"
#import "EnvironmentConfigure.h"

#define CHINAL_ID_APP_STORE @"App Store"
#define CHINAL_ID_ZOL @"zol"
#import <MGTaskPool.h>
@import GoogleMobileAds;
#import <Bugly/Bugly.h>
#import "AppDelegate+RemoteNotification.h"
#import "WPNavigationController.h"
#import "WPMenuViewController.h"
#import "AppDelegate+NetworkMonitor.h"

#import "WPShareManager.h"
#import "AppDelegate+Share.h"

@interface AppDelegate ()<UIApplicationDelegate>{
}

@end

@implementation AppDelegate

/**
 https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=1417694084&token=cc718493c6f2e38fc2e8459453a2f03ce2d3c7ef&lang=zh_CN
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifndef DEBUG
    [Bugly startWithAppId:@"fc2ba95d28"];
#endif
    [GADMobileAds configureWithApplicationID:@"ca-app-pub-7896672979027584~2412534838"];
    [MGTaskPool registerNetworkMediatorWithName:@"WrapperServiceMediator"];
#ifdef DEBUG
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kHasBuySuccess];
#endif
    [self registeShareService];
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];

    WPHomeViewController *homeViewController = [[WPHomeViewController alloc] init];
    WPMenuViewController *menuViewController = [[WPMenuViewController alloc] init];
    WPNavigationController *navigationController = [[WPNavigationController alloc]initWithRootViewController:homeViewController];

    DDMenuController *rootViewController = [[DDMenuController alloc]initWithRootViewController:navigationController];
    rootViewController.leftViewController = menuViewController;
    self.rootViewController = rootViewController;
    self.window.rootViewController = self.rootViewController;
    [self.window makeKeyAndVisible];

    //通知相关
    [self registeRemoteNotificationService];
    [self registeNetworkMonitorService];
    [EnvironmentConfigure shareInstance].startAppTime += 1;

    return YES;
}

-(void)applicationDidBecomeActive:(UIApplication *)application{
    //通知
    [self setRemoteNotificationBadge];
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self categoryApplication:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:nil];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [self categoryApplication:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [self share_application:application handleOpenURL:url];
    return YES;
}


-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [self share_application:application handleOpenURL:url];
    return YES;
}



@end

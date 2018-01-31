//
//  AppDelegate.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-9.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "MenuViewController.h"
#import "EnvironmentConfigure.h"
#import <AFNetworking/AFNetworking.h>
#define CHINAL_ID_APP_STORE @"App Store"
#define CHINAL_ID_ZOL @"zol"
@import GoogleMobileAds;
#import <Bugly/Bugly.h>

@interface AppDelegate (){
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NSThread sleepForTimeInterval:2];
    [Bugly startWithAppId:@"fc2ba95d28"];
    [GADMobileAds configureWithApplicationID:@"ca-app-pub-7896672979027584~2412534838"];

    [[EnvironmentConfigure shareInstance] setShowAllData:NO];

    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // 开启网络监控
    AFNetworkReachabilityManager *netReachabilityManger = [AFNetworkReachabilityManager sharedManager];
    [netReachabilityManger startMonitoring];
    
    UINavigationBar * appearance = [UINavigationBar appearance];
    [appearance setBarTintColor:[UIColor colorWithHex:0x1fb1e8]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    [appearance setTitleTextAttributes:dictionary];
    
    HomeViewController *homeViewController = [[HomeViewController alloc]initWithNibName:@"HomeViewController_iphone" bundle:nil];
    
    MenuViewController *menuViewController = [[MenuViewController alloc]initWithNibName:@"MenuViewController_iphone" bundle:nil];
    
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:homeViewController];
    
    DDMenuController *rootViewController = [[DDMenuController alloc]initWithRootViewController:navigationController];
    rootViewController.leftViewController = menuViewController;
    
    self.rootViewController = rootViewController;
    
    self.window.rootViewController = self.rootViewController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)applicationDidBecomeActive:(UIApplication *)application{
    /**
     * add network status listener
     */
}


@end

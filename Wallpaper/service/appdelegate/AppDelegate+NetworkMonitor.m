//
//  AppDelegate+NetworkMonitor.m
//  Wallpaper
//
//  Created by kyson on 28/03/2018.
//  Copyright © 2018 zhujinhui. All rights reserved.
//

#import "AppDelegate+NetworkMonitor.h"
#import <AFNetworking/AFNetworking.h>

@implementation AppDelegate(NetworkMonitor)

-(void)registeNetworkMonitorService
{
    // 开启网络监控
    AFNetworkReachabilityManager *netReachabilityManger = [AFNetworkReachabilityManager sharedManager];
    [netReachabilityManger startMonitoring];
}

@end

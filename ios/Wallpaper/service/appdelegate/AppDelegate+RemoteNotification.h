//
//  WPNotificationAppDelegate.h
//  Wallpaper
//
//  Created by zhujinhui on 2018/3/9.
//  Copyright © 2018年 zhujinhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface AppDelegate(RemoteNotification)


/**
 注册服务
 */
-(void) registeRemoteNotificationService;



/**
 设置badge
 */
-(void) setRemoteNotificationBadge;

- (void)categoryApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler ;

@end

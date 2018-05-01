//
//  AppDelegate+Share.h
//  Wallpaper
//
//  Created by kyson on 01/05/2018.
//  Copyright © 2018 zhujinhui. All rights reserved.
//

#import "AppDelegate.h"
#import <WXApi.h>

@interface AppDelegate(Share)

/**
 register
 */
-(void)registeShareService;

-(BOOL)share_application:(UIApplication *)application handleOpenURL:(NSURL *)url;

@end

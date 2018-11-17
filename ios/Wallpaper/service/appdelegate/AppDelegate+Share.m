//
//  AppDelegate+Share.m
//  Wallpaper
//
//  Created by kyson on 01/05/2018.
//  Copyright © 2018 zhujinhui. All rights reserved.
//

#import "AppDelegate+Share.h"
#import <WXApi.h>
#import "WPShareManager.h"


@implementation AppDelegate(Share)

-(void)registeShareService
{
    [WXApi registerApp:@"wxa186e910754a13fc"];
}

-(BOOL)share_application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [WXApi handleOpenURL:url delegate:[WPShareManager sharedManager]];
    return YES;
}

@end

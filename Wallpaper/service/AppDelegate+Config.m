//
//  AppDelegate+Config.m
//  Wallpaper
//
//  Created by kyson on 30/03/2018.
//  Copyright © 2018 zhujinhui. All rights reserved.
//

#import "AppDelegate+Config.h"
#import <MGTaskPool.h>
#import "EnvironmentConfigure.h"
#import "WrapperServiceMediator.h"
@implementation AppDelegate(Config)


-(void)appConfigService
{
    [[MGTaskPool shareInstance] doServiceWithName:SERVICENAME_APPCONFIG params:nil];
    [[MGTaskPool shareInstance] addDelegate:self];
}

-(void)taskpool:(MGTaskPool *)pool serviceFinished:(id<MGService>)service response:(MGServiceResponse *)response
{
    if ([service.serviceName isEqualToString:SERVICENAME_APPCONFIG] && response.rawResponseDictionary)
    {
        NSDictionary *content = response.rawResponseDictionary[@"content"];
        BOOL showAllData = [content[@"showallbaby"] boolValue];
        [EnvironmentConfigure shareInstance].showAllData = showAllData;
    }
}

@end

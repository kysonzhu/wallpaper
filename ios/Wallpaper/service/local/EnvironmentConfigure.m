//
//  EnvironmentConfigure.m
//  WallWrapper ( https://github.com/kysonzhu/wallpaper.git )
//
//  Created by zhujinhui on 15/1/19.
//  Copyright (c) 2015年 zhujinhui. All rights reserved.
//

#import "EnvironmentConfigure.h"
#define APP_START_TIME @"START_TIME"
#define SHOW_ALL_DATA_YES @"SHOW_ALL_DATA_YES"
#define SHOW_ALL_DATA_NO @"SHOW_ALL_DATA_NO"

static EnvironmentConfigure *environmentConfigure = nil;

@implementation EnvironmentConfigure

+(EnvironmentConfigure *)shareInstance{
    @synchronized(self){
        if (nil == environmentConfigure)
        {
            environmentConfigure = [[EnvironmentConfigure alloc]init];
        }
    }
    
    return environmentConfigure;
}

-(NSInteger)startAppTime{
    
    NSInteger time = [[NSUserDefaults standardUserDefaults] integerForKey:APP_START_TIME];
    return time;
}

-(void)setStartAppTime:(NSInteger)startAppTime{
    [[NSUserDefaults standardUserDefaults] setInteger:startAppTime forKey:APP_START_TIME];
}





@end

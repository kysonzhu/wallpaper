//
//  Platform.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 15-1-13.
//  Copyright (c) 2015年 zhujinhui. All rights reserved.
//

#import "Platform.h"

@implementation Platform

+(PlatformType)getPlatform{
    PlatformType type ;
    CGRect rect = [UIScreen mainScreen].bounds;
    NSInteger width = rect.size.width * 2;
    NSInteger height = rect.size.height * 2;
    
    if (width == 640 && height == 960) {
        type = PlatformType640960;
    }else if (width == 640 && height == 1136){
        type = PlatformType6401136;
    }else if (width == 1080 && height == 1920){
        type = PlatformTypeiPhone6P;
    }else if (width == 750 && height == 1334){
        type = PlatformTypeiPhone6;
    }else{
        type = PlatformTypeiPhone320480;
    }
    return type;
}

@end

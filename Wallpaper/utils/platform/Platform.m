//
//  Platform.m
//  WallWrapper ( https://github.com/kysonzhu/wallpaper.git )
//
//  Created by zhujinhui on 15-1-13.
//  Copyright (c) 2015年 zhujinhui. All rights reserved.
//

#import "Platform.h"

@implementation Platform

+(PlatformType)getPlatform{
    PlatformType type ;
    CGRect rect = [UIScreen mainScreen].bounds;
    NSInteger width = rect.size.width;
    NSInteger height = rect.size.height;
    if (width == 414 && height == 736)
    {
        type = PlatformType414736;
    }
    else if (width == 375 && height == 667)
    {
        type = PlatformType375667;
    }
    else if (width == 320 && height == 568)
    {
        type = PlatformType320568;
    }
    else if (width == 320 && height == 480)
    {
        type = PlatformType320480;
    }
    else
    {
        
    }
    if (width == 414 && height == 736) {
        type = PlatformType414736; //p
    }else if (width == 375 && height == 667){
        type = PlatformType375667; //6
    }else if (width == 320 && height == 568){
        type = PlatformType320568; //5
    }else if (width == 320 && height == 480){
        type = PlatformType320480; //4s
    }else if (width == 375 * 812){
        type = PlatformTypeX;
    }
    return type;
}

@end

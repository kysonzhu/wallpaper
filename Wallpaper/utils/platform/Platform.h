//
//  Platform.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 15-1-13.
//  Copyright (c) 2015年 zhujinhui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _PlatformType{
    PlatformType640960,
    PlatformType6401136,
    PlatformTypeiPhone6,
    PlatformTypeiPhone6P,
    PlatformTypeiPhone320480
}PlatformType;


@interface Platform : NSObject

+(PlatformType)getPlatform;

@end

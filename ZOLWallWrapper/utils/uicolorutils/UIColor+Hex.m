//
//  UIColor+Hex.m
//  Pitch
//
//  Created by zhujinhui on 14-9-5.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor(hex)

+(UIColor *)colorWithHex:(int)hexColor{
    return [UIColor colorWithRed:((float)((hexColor & 0xFF0000) >> 16))/255.0 green:((float)((hexColor & 0xFF00) >> 8))/255.0 blue:((float)(hexColor & 0xFF))/255.0 alpha:1.0];
}


+(UIColor *)colorWithHex:(int)hexColor alpha:(float) alphaValue{
    return [UIColor colorWithRed:((float)((hexColor & 0xFF0000) >> 16))/255.0 green:((float)((hexColor & 0xFF00) >> 8))/255.0 blue:((float)(hexColor & 0xFF))/255.0 alpha:(alphaValue)];
}
@end

//
//  UIColor+Hex.h
//  Pitch
//
//  Created by zhujinhui on 14-9-5.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (hex)

/**
 *convert hex value to color
 */
+(UIColor *)colorWithHex:(int)hexColor;

/**
 *convert hex value to color with alpha value
 */

+(UIColor *)colorWithHex:(int)hexColor alpha:(float) alphaValue;

@end

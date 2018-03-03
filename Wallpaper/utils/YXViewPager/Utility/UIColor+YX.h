//
//  UIColor+YX.h
//  Pods
//
//  Created by yixiang on 17/3/29.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (YX)

+ (UIColor *)colorWithHexString:(NSString *)hexString;

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end

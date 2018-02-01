//
//  UIScrollView+touch.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 15-1-15.
//  Copyright (c) 2015年 zhujinhui. All rights reserved.
//

#import "UIScrollView+touch.h"

@implementation UIScrollView (touch)



#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
-(BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view{
    BOOL shouldBegin = NO;
    if ([view isKindOfClass:[UIView class]]) {
        shouldBegin = YES;
    }
    return shouldBegin;
}
#pragma clang diagnostic pop


@end

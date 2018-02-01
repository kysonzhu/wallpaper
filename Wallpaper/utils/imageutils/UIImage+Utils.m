//
//  UIImage+Utils.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-25.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "UIImage+Utils.h"

@implementation UIImage(private)


-(UIImage *)scaleto:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width*scaleSize,self.size.height*scaleSize));
    [self drawInRect:CGRectMake(0, 0, self.size.width * scaleSize, self.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end

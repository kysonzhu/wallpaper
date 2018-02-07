//
//  ViewPagerAdapter.h
//  WallWrapper ( https://github.com/kysonzhu/wallpaper.git )
//
//  Created by zhujinhui on 14-12-23.
//  Copyright (c) 2014年 zhujinhui( http://kyson.cn ). All rights reserved.
//

#import <Foundation/Foundation.h>

@class ViewPager;



@interface ViewPagerAdapter : NSObject

@property (nonatomic, strong) NSArray *views;


-(id)init;

-(NSUInteger)numberOfPages:(ViewPager *)pager ;


-(UIView *)getItem:(int) position;


@end

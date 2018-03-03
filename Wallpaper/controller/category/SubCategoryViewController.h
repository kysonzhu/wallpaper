//
//  CategoryViewController.h
//  WallWrapper ( https://github.com/kysonzhu/wallpaper.git )
//
//  Created by zhujinhui on 14-12-24.
//  Copyright (c) 2014年 zhujinhui( http://kyson.cn ). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Classification.h"
#import "WPBaseViewController.h"

@interface SubCategoryViewController : WPBaseViewController

@property (nonatomic, strong) Classification *category;

@end

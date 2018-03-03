//
//  WrapperDetailViewController.h
//  WallWrapper ( https://github.com/kysonzhu/wallpaper.git )
//
//  Created by zhujinhui on 14-12-17.
//  Copyright (c) 2014年 zhujinhui( http://kyson.cn ). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"
#import "WPBaseViewController.h"

typedef enum _FromController{
    FromControllerRecommended,
    FromControllerLatest,
    FromControllerHotest
}FromController;

@interface WrapperDetailViewController : WPBaseViewController

@property (nonatomic, retain) Group *group;

@property (nonatomic, assign) FromController fromcontroller;


@end

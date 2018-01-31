//
//  WrapperDetailViewController.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-17.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"

typedef enum _FromController{
    FromControllerRecommended,
    FromControllerLatest,
    FromControllerHotest
}FromController;

@interface WrapperDetailViewController : Controller

@property (nonatomic, retain) Group *group;

@property (nonatomic, assign) FromController fromcontroller;


@end

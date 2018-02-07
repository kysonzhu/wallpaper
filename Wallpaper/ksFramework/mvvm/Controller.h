//
//  Controller.h
//  WallWrapper ( https://github.com/kysonzhu/wallpaper.git )
//
//  Created by zhujinhui on 14-12-27.
//  Copyright (c) 2014年 zhujinhui( http://kyson.cn ). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MGTaskPool.h>
#import <MGNetworkServiceMediator.h>
#import <MGNetwokResponse.h>
#import "KVNProgress.h"
#import <Masonry/Masonry.h>

#define TAG_IMGV_OUTOFNETWORK  8913

@interface Controller : UIViewController

-(void)doNetworkService:(MGNetworkServiceMediator *) service;

-(void)refreshData:(NSString *)serviceName response:(MGNetwokResponse *)response;


@end

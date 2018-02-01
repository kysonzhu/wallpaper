//
//  Controller.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-27.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskPool.h"
#import "ServiceMediator.h"
#import "KVNProgress.h"
#import "OutOfNetworkView.h"
#import <Masonry/Masonry.h>

#define TAG_IMGV_OUTOFNETWORK  8913

@interface Controller : UIViewController

-(OutOfNetworkView *)outOfNetworkView;

-(void)doNetworkService:(ServiceMediator *) service;

-(void)refreshData:(NSString *)serviceName response:(NetworkResponse *)response;


@end

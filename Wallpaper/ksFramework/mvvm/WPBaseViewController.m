//
//  Controller.m
//  WallWrapper ( https://github.com/kysonzhu/wallpaper.git )
//
//  Created by zhujinhui on 14-12-27.
//  Copyright (c) 2014年 zhujinhui( http://kyson.cn ). All rights reserved.
//

#import "WPBaseViewController.h"
#import "ImageCache.h"
#import "AppDelegate.h"
#import <AFNetworking/AFNetworking.h>

@interface WPBaseViewController ()<MGTaskPoolDelegate>{
    NSMutableArray *requestTokens;
}

@property (nonatomic,strong) MGTaskPool *taskPool;


@end

@implementation WPBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    requestTokens = [[NSMutableArray alloc]init];
}


-(void)handleNavigationWithScrollView:(UIScrollView *) scrollView;
{
    self.navigationController.navigationBar.translucent = NO;
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    /**
     * clear all
     */
    [[ImageCache shareInstance] clearCache];
}

//network

-(MGTaskPool *)taskPool{
    return [MGTaskPool shareInstance];
}

- (void)showNetWorkStateError
{
    
}

-(void)doNetworkService:(MGNetworkServiceMediator *) service{
    [self.taskPool addDelegate:self];
    [requestTokens addObject:service.serviceName];
    [self.taskPool doTaskWithService:service];
}



-(void)taskpool:(MGTaskPool *)pool serviceFinished:(MGNetworkServiceMediator *)service response:(MGNetwokResponse *)response{
    
    [self refreshData:service.serviceName response:response];
}


-(void)refreshData:(NSString *)serviceName response:(MGNetwokResponse *)response{
    
}

-(void)dealloc{
    //cancel all tasks
    for (NSString *taskItem in requestTokens) {
        [self.taskPool cancelServiceWithName:taskItem];
    }
    
}


@end

//
//  Controller.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-27.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "Controller.h"
#import "ImageCache.h"
#import "AppDelegate.h"
#import <AFNetworking/AFNetworking.h>

@interface Controller ()<MGTaskPoolDelegate>{
    NSMutableArray *requestTokens;
}

@property (nonatomic,strong) MGTaskPool *taskPool;

@end

@implementation Controller

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    requestTokens = [[NSMutableArray alloc]init];
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

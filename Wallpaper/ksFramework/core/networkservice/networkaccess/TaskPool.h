//
//  TaskPool.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-26.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceMediator.h"
#import "NetworkResponse.h"


@protocol TaskPoolDelegate;


@interface TaskPool : NSObject

@property (nonatomic,weak) id<TaskPoolDelegate> mDelegate;

+(TaskPool *) shareInstance;

-(void)doTaskWithService:(ServiceMediator *) service;


-(BOOL)cancelTaskWithService:(NSString *) service;


@end

@protocol TaskPoolDelegate <NSObject>

-(void)taskpool:(TaskPool *) pool serviceFinished:(ServiceMediator *)service response:(NetworkResponse *) response;

@end
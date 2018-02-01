//
//  ServiceMediator.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-26.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonHandler.h"

#define MODEL_PARAMS @"ParamsModel"

@protocol ServiceMediatorDelegate;


@interface ServiceMediator : NSOperation


@property (nonatomic, copy) NSString *serviceName;

@property (nonatomic, copy) NSString *methodName;

@property (nonatomic, strong) NSArray *paramNames;



@property (nonatomic, assign) id<ServiceMediatorDelegate> mDelegate;

-(id)initWithName:(NSString *) serviceName;




@end


@protocol ServiceMediatorDelegate <NSObject>

-(void)service:(ServiceMediator *)service
serviceResponse:(NetworkResponse *)response;

@end
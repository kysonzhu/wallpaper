//
//  NetworkResponse.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-26.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkResponse : NSObject


@property (nonatomic, copy)     NSString *rawJson;

@property (nonatomic, retain)   id response;

@property (nonatomic, assign)   NSInteger errorCode;

@property (nonatomic, copy)     NSString  *errorMessage;


@end

//
//  NetworkAccess.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-26.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpHeaderField.h"
#import "NetworkResponse.h"


typedef enum _RequestType{
    RequestTypePost = 0,
    RequestTypeGet
}RequestType;

#define TIMEOUT_INTERVAL 16.0


@interface NetworkAccess : NSObject

@property (nonatomic, retain) NSString *host;

@property (nonatomic, retain) HttpHeaderField *httpHeaderField;

@property (nonatomic, assign) RequestType requestType;

-(NetworkResponse *)doHttpRequest:(NSString *)requestUrlString
                           params:(NSDictionary *) params;


@end

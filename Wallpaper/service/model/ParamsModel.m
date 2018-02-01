//
//  ParamsModel.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-27.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "ParamsModel.h"

static ParamsModel *paramsModel;

@implementation ParamsModel


+(id) shareInstance{
    if (nil == paramsModel) {
        @synchronized(self){
            paramsModel = [[ParamsModel alloc]init];
        }
    }
    return paramsModel;
    
}



@end

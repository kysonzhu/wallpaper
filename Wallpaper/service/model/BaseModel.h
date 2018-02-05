//
//  BaseModel.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-26.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface BaseModel : NSObject

//+(id) shareInstance;

-(NSDictionary *)allProperties;


-(BOOL) isEqualTo:(BaseModel *) std;

-(BaseModel *)setPropertiesWithDictionary:(NSDictionary *)dictionary;

@end

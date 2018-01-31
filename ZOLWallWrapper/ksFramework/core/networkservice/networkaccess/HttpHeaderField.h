//
//  HttpHeaderField.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-26.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpHeaderField : NSObject

@property (nonatomic ,copy) NSString *contentType;


-(NSDictionary *)httpHeaders;

@end

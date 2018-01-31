//
//  HttpHeaderField.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-26.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "HttpHeaderField.h"

@implementation HttpHeaderField


-(NSDictionary *)httpHeaders{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if (nil != _contentType) {
        [dictionary setObject:_contentType forKey:@"content-type"];
    }
    return dictionary;
}





@end

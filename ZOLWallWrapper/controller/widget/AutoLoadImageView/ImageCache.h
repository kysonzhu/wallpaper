//
//  ImageCache.h
//  Pitch
//
//  Created by zhujinhui on 14-9-29.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject

+(ImageCache* )shareInstance;


-(void)cacheImageWith32Key:(NSString *)key;

-(UIImage *)loadCacheImageWith32Key:(NSString *)key;

-(void)removeCache:(NSString *)key;

-(void)clearCache;

@end

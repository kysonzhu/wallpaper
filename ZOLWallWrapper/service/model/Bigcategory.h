//
//  Category.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-30.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bigcategory : BaseModel

@property (nonatomic, copy) NSString *cateId;
@property (nonatomic, copy) NSString *cateName;
@property (nonatomic, copy) NSString *cateShortName;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *fatherId;

@end

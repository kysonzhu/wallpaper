//
//  Classification.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-30.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "BaseModel.h"

@interface Classification : BaseModel


@property (nonatomic, copy) NSString *cateId;
@property (nonatomic, copy) NSString *cateName;
@property (nonatomic, copy) NSString *cateShortName;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *fatherId;
@property (nonatomic, copy) NSString *coverImgUrl;
@property (nonatomic, copy) NSString *keyword;



@end

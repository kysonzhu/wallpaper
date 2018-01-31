//
//  Group.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-27.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface Group : BaseModel

@property (nonatomic, copy) NSString *gId;
@property (nonatomic, copy) NSString *gName;
@property (nonatomic, copy) NSString *voteGood;
@property (nonatomic, copy) NSString *subId;
@property (nonatomic, copy) NSString *downNum;
@property (nonatomic, copy) NSString *editDate;
@property (nonatomic, copy) NSString *coverImgUrl;
@property (nonatomic, copy) NSString *picNum;


@end

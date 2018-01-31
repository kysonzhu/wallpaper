//
//  ParamsModel.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-27.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "BaseModel.h"

@interface ParamsModel : BaseModel

@property (nonatomic,copy) NSString *gId;
//@property (nonatomic,copy) NSString *picSize;
@property (nonatomic,copy) NSString *cateId;
@property (nonatomic,copy) NSString *fatherId;
@property (nonatomic,copy) NSString *subId;
@property (nonatomic,copy) NSString *start;
@property (nonatomic,copy) NSString *word;


+(id) shareInstance;

@end

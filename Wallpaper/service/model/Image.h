//
//  Image.h
//  WallWrapper ( https://github.com/kysonzhu/wallpaper.git )
//
//  Created by zhujinhui on 14-12-29.
//  Copyright (c) 2014年 zhujinhui( http://kyson.cn ). All rights reserved.
//

#import "KSModel.h"

@interface Image : KSModel

@property (nonatomic, copy) NSString *gId;
@property (nonatomic, copy) NSString *gName;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *pId;

//以下为kyson的image 属性
@property (nonatomic, copy) NSString *babyImgUrl;


@end

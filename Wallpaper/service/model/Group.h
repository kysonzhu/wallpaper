//
//  Group.h
//  WallWrapper ( https://github.com/kysonzhu/wallpaper.git )
//
//  Created by zhujinhui on 14-12-27.
//  Copyright (c) 2014年 zhujinhui( http://kyson.cn ). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSModel.h"

@interface Group : KSModel

CREATE_STRING_PROPERTY(gId)
CREATE_STRING_PROPERTY(gName)
CREATE_STRING_PROPERTY(voteGood)
CREATE_STRING_PROPERTY(subId)
CREATE_STRING_PROPERTY(downNum)
CREATE_STRING_PROPERTY(editDate)
CREATE_STRING_PROPERTY(coverImgUrl)
CREATE_STRING_PROPERTY(picNum)
CREATE_STRING_PROPERTY(wallPaperSource) //壁纸来源1、zol 2、kyson
CREATE_STRING_PROPERTY(id)


@end

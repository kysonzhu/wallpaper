//
//  EnvironmentConfigure.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 15/1/19.
//  Copyright (c) 2015年 zhujinhui. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ID_EVENT_SHARE          @"10000"
#define ID_EVENT_CLEAR_CACHE    @"10001"
#define ID_EVENT_LOCK_SHOW      @"10002"
#define ID_EVENT_LOCK_LAUNTCH   @"10003"
#define ID_EVENT_DOWNLOAD       @"10004"
#define ID_EVENT_PRAISE         @"10005"


@interface EnvironmentConfigure : NSObject{
    
    
}

@property (nonatomic, assign) BOOL showAllData;


+(EnvironmentConfigure *)shareInstance;



-(BOOL) shouldFilter:(NSString *) gName;


@end

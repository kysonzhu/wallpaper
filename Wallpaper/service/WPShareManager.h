//
//  WPShareManager.h
//  Wallpaper
//
//  Created by kyson on 01/05/2018.
//  Copyright © 2018 zhujinhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WXApi.h>

typedef enum : NSUInteger {
    WPShareTypeMessage,
    WPShareTypePicture,
    WPShareTypeVideo,
} WPShareType;


@interface WPShareManager : NSObject<WXApiDelegate>


/**
 对象创建方法 单例

 @return shareManager
 */
+(WPShareManager *)sharedManager;


/**
 分享

 @param imageURL URL
 @param shareType 分享类型
 */
+(void)shareWithURL:(NSString *)imageURL type:(WPShareType) shareType finished:(void (^)(BOOL success))block;


@end

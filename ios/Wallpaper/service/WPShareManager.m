//
//  WPShareManager.m
//  Wallpaper
//
//  Created by kyson on 01/05/2018.
//  Copyright © 2018 zhujinhui. All rights reserved.
//

#import "WPShareManager.h"

#import <WXApiObject.h>
#import <SDWebImageDownloader.h>

@implementation WPShareManager



+(WPShareManager *)sharedManager {
    return nil;
}



+(void)shareWithURL:(NSString *)imageURL type:(WPShareType) shareType finished:(void (^)(BOOL success))block
{
    NSURL *url = [NSURL URLWithString:imageURL];
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        ;
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        
        if (image != nil)
        {
            WXMediaMessage * message = [WXMediaMessage message];
            message.title = @"壁纸宝贝为您推荐一位宝贝！";
            UIImage *appIcon = [UIImage imageNamed:@"AppIcon"];
            NSData *iconData = UIImagePNGRepresentation(appIcon);
            message.thumbData = iconData;
            //media Object
            WXImageObject *mediaObj = [WXImageObject object];
            mediaObj.imageData = data;
            //set Object
            message.mediaObject = mediaObj;
            //创建请求
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = message;
            //发送请求
            [WXApi sendReq:req];
            
            if (block) {
                block(YES);
            }
            
        } else{
            block(NO);
        }
        
    }];
}



-(void) onReq:(BaseReq*)reqonReq {
    
}

-(void) onResp:(BaseResp*)resp {
    //response
}

@end

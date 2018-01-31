//
//  ImageDownloader.h
//  Pitch
//
//  Created by zhujinhui on 14-9-29.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageDownloaderDelegate;

@interface ImageDownloader : NSObject

@property (nonatomic, assign) id<ImageDownloaderDelegate> mDelegate;

@property (nonatomic, assign) BOOL showProgress;

//+(ImageDownloader *) shareInstance;


-(void)downloadImageWithUrl:(NSString *)imgUrl;

-(void)cancelDownload;

@end



@protocol ImageDownloaderDelegate <NSObject>
@optional

-(void)imageDownloader:(ImageDownloader *)downloader downloadFinishedWithData:(NSData *)imgData;
//
-(void)imageDownloader:(ImageDownloader *)downloader downloadFinishedWithImage:(UIImage *)img;

-(void)imageDownloader:(ImageDownloader *)downloader downloadErrorWithError:(NSString *)error;


@end

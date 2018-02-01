//
//  ImageDownloader.m
//  Pitch
//
//  Created by zhujinhui on 14-9-29.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "ImageDownloader.h"
#import "NSString+Util.h"
#import "FileDownload.h"
#import "ImageCache.h"
#import "FileManager.h"

#import "UIImage+Compress.h"
#import "FileDownload.h"

#define IMAGELENGTH 204800

@interface ImageDownloader()<FileDownloadDelegate>{
    ImageCache *imageCache;
    FileDownload *fileDownload;
}

@end

@implementation ImageDownloader

-(id)init{
    if (self = [super init]) {
        @synchronized(self){
            imageCache = [ImageCache shareInstance];
        }
    }
    return self;
}


-(void)downloadImageWithUrl:(NSString *)imgUrl{
    NSString *md5 = [imgUrl md5];
    UIImage *cachedImage = [imageCache loadCacheImageWith32Key:md5];
    
    if (0x00 == cachedImage) {
        //get file at sandbox
        BOOL exist = [FileManager isFileExists:md5 type:DirectoryTypeDocument];
        if (exist) {
            [imageCache cacheImageWith32Key:md5];
            cachedImage = [imageCache loadCacheImageWith32Key:md5];
            
            //callback
            if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(imageDownloader:downloadFinishedWithImage:)]) {
                [self.mDelegate imageDownloader:self downloadFinishedWithImage:cachedImage];
            }
            
        }else{
            //start down load
            fileDownload = [[FileDownload alloc]initWithFileUrl:imgUrl];
            fileDownload.mDelegate = self;
            [fileDownload startDownload];
        }
        
    }else{
        //callback
        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(imageDownloader:downloadFinishedWithImage:)]) {
            [self.mDelegate imageDownloader:self downloadFinishedWithImage:cachedImage];
        }
        
    }
    
}

#pragma mark - FileDownloadDelegate
-(void)fileDownloadDidFinish:(FileDownload *)filedownload data:(NSData *)data{
    NSString *md5 = [filedownload.fileUrl md5];
    [imageCache cacheImageWith32Key:md5];
    UIImage *cachedImage = [imageCache loadCacheImageWith32Key:md5];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        //call back
        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(imageDownloader:downloadFinishedWithImage:)]) {
            [self.mDelegate imageDownloader:self downloadFinishedWithImage:cachedImage];
        }
    });
}

-(void)fileDownloadError:(FileDownload *)filedownload error:(NSString *)error{
    dispatch_sync(dispatch_get_main_queue(), ^{
        //call back
        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(imageDownloader:downloadErrorWithError:)]) {
            [self.mDelegate imageDownloader:self downloadErrorWithError:error];
        }
    });
}


-(void)cancelDownload{
    [fileDownload cancelDownload];
}

- (void)dealloc
{
    self.mDelegate = nil;
    [self cancelDownload];
    fileDownload.mDelegate = nil;
}



@end

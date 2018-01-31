//
//  FileDownload.h
//  Pitch
//
//  Created by zhujinhui on 14-9-29.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FileDownloadDelegate ;

@interface FileDownload : NSObject

@property (nonatomic, assign) id<FileDownloadDelegate> mDelegate;

@property (nonatomic, copy) NSString *fileUrl;

-(id) initWithFileUrl:(NSString *)fileUrl;

-(void)startDownload;

-(void)cancelDownload;

@end

@protocol FileDownloadDelegate <NSObject>

@optional

-(void)fileDownload:(FileDownload *) filedownload downloadPrgoress:(float) percent;

-(void)fileDownloadDidFinish:(FileDownload *) filedownload data:(NSData *)data;

-(void)fileDownloadError:(FileDownload *) filedownload error:(NSString *)error;

@end


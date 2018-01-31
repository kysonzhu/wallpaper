//
//  FileDownload.m
//  Pitch
//
//  Created by zhujinhui on 14-9-29.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "FileDownload.h"
#import "FileManager.h"
#import "UIImage+Compress.h"
#import "NSString+Util.h"

#define IMAGELENGTH 204800

#define ERRORSIZE 18

static NSString *picSizeError = @"picture size error";

@interface FileDownload ()<NSURLConnectionDelegate,NSURLConnectionDataDelegate>{
    NSURLConnection *connection;
    long long receiveLength;
    long long contentLength;
    NSMutableData *receiveData;
    //
    NSInvocationOperation *filedownloadImpl;
}

@property (nonatomic, assign) BOOL isFinished;


@end

static NSOperationQueue *filedownloadPool = nil;

@implementation FileDownload

-(id) init{
    if (self = [super init]) {
        if (nil == filedownloadPool) {
            filedownloadPool = [[NSOperationQueue alloc]init];
        }
        [filedownloadPool setMaxConcurrentOperationCount:5];
    }
    return self;
}

- (id)initWithFileUrl:(NSString *)fileUrl{
    if (self = [self init]) {
        self.fileUrl = fileUrl;
    }
    return self;
}

-(void)startDownload{
    filedownloadImpl = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(main) object:nil];
    [filedownloadPool addOperation:filedownloadImpl];
}


-(void)main{
    NSURL *fileUrl = [NSURL URLWithString:_fileUrl];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:fileUrl];
    connection =[[NSURLConnection alloc] initWithRequest:request
                                                     delegate:self
                                             startImmediately:YES];
//    [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    if (connection) {
        receiveData = [NSMutableData data];
    }

    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate distantFuture]];
    } while (!self.isFinished);
    
    [connection start];
}


#pragma mark - NSURLConnectionDelegate
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    self.isFinished = YES;

}

-(void)setFinishedConnect{
    self.isFinished = YES;
}

/**
 */
#pragma mark - NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    contentLength = [response expectedContentLength];
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    receiveLength += [data length];
    [receiveData appendData:data];
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(fileDownload:downloadPrgoress:)]) {
        float percent = receiveLength/contentLength;
        [self.mDelegate fileDownload:self downloadPrgoress:percent ];
    }
    if (contentLength == receiveLength) {
        /**
         * Check if has error,error size is 18,as known, is "picture size error".
         * if size is not 18, it must have no error,but if it is 18 ,perhaps it has errors
         * it also has no errors,it all depends on the data.
         */
        if (contentLength != ERRORSIZE) {
            [self finishDownload];
        }else{
            NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            if ([string isEqualToString:picSizeError]) {
                if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(fileDownloadError:error:)]) {
                    [self.mDelegate fileDownloadError:self error:picSizeError];
                    // set down load finish
                }
            }else{
                [self finishDownload];
            }
        }
        self.isFinished = YES;
    }
}

-(void)finishDownload{
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(fileDownloadDidFinish:data:)]) {
        //save
        [FileManager writeFile:[self.fileUrl md5] toDirectory:DirectoryTypeDocument withData:receiveData];
        [self.mDelegate fileDownloadDidFinish:self data:receiveData];
        // set down load finish
    }
}


-(void)cancelDownload{
    [filedownloadImpl cancel];
    self.isFinished = YES;
}

-(void)dealloc{
    self.mDelegate = nil;
}

@end
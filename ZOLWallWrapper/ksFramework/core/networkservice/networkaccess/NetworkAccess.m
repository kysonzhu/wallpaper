//
//  NetworkAccess.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-26.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "NetworkAccess.h"
#import "MockAccess.h"

@implementation NetworkAccess

- (id)init
{
    self = [super init];
    if (self) {
        self.requestType = RequestTypeGet;
    }
    return self;
}


-(NetworkResponse *)doHttpRequest:(NSString *)requestUrlString
              params:(NSDictionary *) params{
    /**
     * Judge if it is mock access
     */
    if (nil == _host) {
        MockAccess *mock = [[MockAccess alloc]init];
        [mock doHttpRequest:requestUrlString params:params];
        return  nil;
    }
    
    if (![requestUrlString hasPrefix:@"http://"]) {
        requestUrlString = [NSString stringWithFormat:@"%@/%@",_host,requestUrlString];
    }
    NSURL *url = [NSURL URLWithString:requestUrlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    request.timeoutInterval = TIMEOUT_INTERVAL;
    // use any cache
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    /**
     * http request header
     */
    
    if (nil != _httpHeaderField) {
        NSDictionary *allHeaders = [_httpHeaderField httpHeaders];
        NSArray *arrKey = [allHeaders allKeys];
        for (int i = 0 ; i < [arrKey count]; ++i) {
            NSString *key = [arrKey objectAtIndex:i];
            NSString *value = [allHeaders objectForKey:key];
            [request setValue:value forHTTPHeaderField:key];
        }
    }else{
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    }
    
    
    /**
     * request type
     */
    switch (self.requestType) {
        case RequestTypeGet:{
            NSMutableString *string = [[NSMutableString alloc]initWithString:requestUrlString];
            NSArray *arrKey = [params allKeys];
            for (int i = 0 ; i < [arrKey count]; ++i) {
                NSString *key = [arrKey objectAtIndex:i];
                NSString *value = [params objectForKey:key];
                if (0 == i) {
                    [string appendFormat:@"?%@=%@",key,value];
                }else{
                    [string appendFormat:@"&%@=%@",key,value];
                }
            }
            //use utf-8 encoding
            NSString *string2 = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"kyson:%@:%@",self,string2);
            url = [NSURL URLWithString:string2];
            request.URL = url;
        }
            break;
        case RequestTypePost:{
            NSLog(@"kyson:%@:%@",self,requestUrlString);
        }
            break;
            
        default:
            break;
    }
    
    NSError *requestError = nil;
    //start request
    NSData *resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&requestError];
    NetworkResponse *response = [[NetworkResponse alloc]init];
    if (requestError) {
        if (NSURLErrorCannotConnectToHost == requestError.code ) {
            response.errorMessage = @"连接服务器失败，请检查您的网络!";
            response.errorCode = NSURLErrorCannotConnectToHost;
        }else if (NSURLErrorTimedOut == requestError.code){
            response.errorMessage = @"超时，请检查您的网络!";
            response.errorCode = NSURLErrorTimedOut;
        }else if(NSURLErrorNotConnectedToInternet == requestError.code){
            response.errorCode = NSURLErrorNotConnectedToInternet;
            response.errorMessage = @"网络似乎已经断开";
        }else{
            response.errorCode = 89898989;
            response.errorMessage = @"服务器被外星人劫持了!";
        }
    }else{
        NSString *resultString = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        NSLog(@"kyson raw resultString:%@",resultString);
        response.rawJson = resultString;
        [JsonHandler convertToErrorResponse:&response];
    }
    return response;
}







@end

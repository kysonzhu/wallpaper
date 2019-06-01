//
//  WPRHomeViewModel.m
//  Wallpaper
//
//  Created by kyson on 2019/6/1.
//  Copyright © 2019 zhujinhui. All rights reserved.
//

#import "WPRHomeViewModel.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>

@interface WPRHomeViewModel ()

@property (nonatomic, strong, readwrite) NSArray<WPRBaby *> *babies;
@property (nonatomic, strong, readwrite) RACCommand *babiesListCommand;
@property (nonatomic, strong, readwrite) RACCommand *wallPaperListCommand;

@end


@implementation WPRHomeViewModel


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initilize];
    }
    return self;
}

-(void)initilize {
    
}


-(RACCommand *)babiesListCommand {
    if (!_babiesListCommand) {
        _babiesListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                //1.创建会话管理者
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                
                [manager GET:@"https://www.kyson.cn/wallpaper/index.php/v2_0_babyList" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *responseDict = responseObject;
                    if([responseDict isKindOfClass:[NSDictionary class]]) {
                        NSArray *result = responseDict[@"content"];
                        if ([result isKindOfClass:[NSArray class]]) {
                            NSArray *babies = [WPRBaby mj_objectArrayWithKeyValuesArray:result];
                            [subscriber sendNext:babies];
                        }
                        
                    }
                    NSLog(@"%@---%@",[responseObject class],responseObject);
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"请求失败--%@",error);
                    [subscriber sendError:error];
                }];
                
                RACDisposable *dispose = [RACDisposable disposableWithBlock:^{
                    
                }];
                
                return dispose;
                
            }];
            
            return signal;
        }] ;
        _babiesListCommand.allowsConcurrentExecution = YES;
    }
    return _babiesListCommand;
}


-(RACCommand *)wallPaperListCommand {
    if (!_wallPaperListCommand) {
        _wallPaperListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                //1.创建会话管理者
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                
                [manager GET:@"https://www.kyson.cn/wallpaper/index.php/v2_0_wallPaperList" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *responseDict = responseObject;
                    if([responseDict isKindOfClass:[NSDictionary class]]) {
                        NSArray *result = responseDict[@"content"];
                        if ([result isKindOfClass:[NSArray class]]) {
                            NSArray *babies = [WPRBaby mj_objectArrayWithKeyValuesArray:result];
                            [subscriber sendNext:babies];
                        }
                    }
                    NSLog(@"%@---%@",[responseObject class],responseObject);
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"请求失败--%@",error);
                    [subscriber sendError:error];
                }];
                
                RACDisposable *dispose = [RACDisposable disposableWithBlock:^{
                    
                }];
                
                return dispose;
                
            }];
            
            return signal;
        }] ;
        _wallPaperListCommand.allowsConcurrentExecution = YES;
    }
    return _wallPaperListCommand;
}

@end

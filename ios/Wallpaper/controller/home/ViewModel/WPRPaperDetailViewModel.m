//
//  WPRPaperDetailViewModel.m
//  Wallpaper
//
//  Created by kyson on 2019/6/1.
//  Copyright © 2019 zhujinhui. All rights reserved.
//

#import "WPRPaperDetailViewModel.h"
#import "WPRBaby.h"

#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>

@interface WPRPaperDetailViewModel()

@property (nonatomic, strong, readwrite) RACCommand *babyDetailCommand;

@end


@implementation WPRPaperDetailViewModel


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


-(RACCommand *)babyDetailCommand {
    if (!_babyDetailCommand) {
        _babyDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                //1.创建会话管理者
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                NSDictionary *params = @{@"id":input};
                [manager POST:@"https://kyson.cn/wallpaper/index.php/v2_babyImageDetail" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
        _babyDetailCommand.allowsConcurrentExecution = YES;
    }
    return _babyDetailCommand;
}
@end

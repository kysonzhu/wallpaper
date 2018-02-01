//
//  TaskPool.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-26.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "TaskPool.h"


@interface TaskPool ()<ServiceMediatorDelegate>{
}

@property (nonatomic, strong) NSOperationQueue *pool;
@property (nonatomic, strong) NSMutableArray *taskTokens;
@property (nonatomic, assign) NSInteger requestCount;


@end


@implementation TaskPool

static TaskPool *taskPool = nil;

+(TaskPool *) shareInstance{
    if (nil == taskPool) {
        @synchronized(self){
            taskPool = [[TaskPool alloc]init];
            taskPool.pool = [[NSOperationQueue alloc]init];
            [taskPool.pool setMaxConcurrentOperationCount:5];
            
            taskPool.taskTokens = [[NSMutableArray alloc]init];
            taskPool.requestCount = 0;
        }
    }
    return taskPool;
}

-(void)doTaskWithService:(ServiceMediator *)service{
    if (nil == service.mDelegate) {
        service.mDelegate = self;
    }
    NSString *serviceName = service.serviceName;
    
    for (NSString *servieName in self.taskTokens) {
        if ([servieName isEqualToString:service.serviceName]) {
            ++_requestCount;
            serviceName = [NSString stringWithFormat:@"%@@%li",serviceName,(long)self.requestCount];
        }
    }
    [self.taskTokens addObject:serviceName];
    [self.pool addOperation:service];
}


/**
   cancel task with name
 @param taskName
 @returns void
 @exception nil
 @see 
 */
-(BOOL)cancelTaskWithService:(NSString *) serviceName{
    //new a temp tasktokens ,because we will remove object from property "taskTokens"
    NSMutableArray *taskTokensTemp = [[NSMutableArray alloc]initWithArray:self.taskTokens];
    for (NSString *serviceTokenItem in taskTokensTemp) {
        
        NSArray *serviceNameFromToken = [serviceTokenItem componentsSeparatedByString:@"@"];
        
        if ([serviceName isEqualToString:serviceNameFromToken[0]]) {
            
            for (ServiceMediator *serviceItem in self.pool.operations) {
                if ([serviceItem.serviceName isEqualToString:serviceName]) {
                    [serviceItem cancel];
                }
            }
            [self.taskTokens removeObject:serviceTokenItem];

        }
    }
    
    
    
    return YES;
}

-(void)service:(ServiceMediator *)service serviceResponse:(NetworkResponse *)response{
    if (nil != self.mDelegate && [self.mDelegate respondsToSelector:@selector(taskpool:serviceFinished:response:)]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // update ui and other action show execute on main thread
            [self.mDelegate taskpool:self serviceFinished:service response:response];
        });
        
    }
}



@end

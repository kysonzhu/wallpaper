//
//  ServiceMediator.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-26.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "ServiceMediator.h"
#import "BaseModel.h"

@implementation ServiceMediator


-(id)initWithName:(NSString *) serviceName{
    if (self = [super init]) {
        self.serviceName = serviceName;
    }
    return self;
}


-(void)main{
    NSString *method = self.methodName;
    SEL service =NSSelectorFromString(method);
    NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:service];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setTarget:self];
    [invocation setSelector:service];
    Class aClass = NSClassFromString(MODEL_PARAMS);
    BaseModel *model = (BaseModel *)[aClass shareInstance] ;
    if (_paramNames && [_paramNames count] > 0) {
        NSInteger count = [_paramNames count];
        //set params
        for (int i = 0 ; i < count ; ++i) {
            NSString *keyItem = _paramNames [i];
            NSString *paramValue = [model valueForKey:keyItem];
            if (paramValue) {
                [invocation setArgument:&paramValue atIndex:i+2];
            }else{
                NSLog(@"kyson:params %@ is nil,please set it on the model",keyItem);
            }
        }
    }else{
        NSLog(@"there is no params is found");
    }
    
    [invocation retainArguments];
    
    
    /**
     * get result and call back
     */
    NetworkResponse *__autoreleasing response = nil;
    
    [invocation invoke];
    [invocation getReturnValue:&response];
    
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(service:serviceResponse:)]) {
        if (nil == response) {
            NSLog(@"kyson:%@:no response",self);
        }else{
            [self.mDelegate service:self serviceResponse:response];
        }
        
    }
    
}

-(void)doAction{
    
}




@end

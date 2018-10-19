//
//  KSRouter.m
//  Wallpaper
//
//  Created by kyson on 02/03/2018.
//  Copyright © 2018 zhujinhui. All rights reserved.
//

#import "KSRouter.h"

@implementation KSRouter

+(void)load{
    [self shareRouter];
}

static KSRouter *_instance;
+(KSRouter *)shareRouter{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [[super alloc]init];
        }
    });
    return _instance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        ;
    }
    return self;
}

-(void)routeWithServiceName:(NSString *)serviceName params:(NSString *)parms{
    
}




@end

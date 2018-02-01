//
//  BaseModel.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-26.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>


@implementation BaseModel

//static BaseModel *baseModel = nil;


//+(id) shareInstance{
//    if (nil == baseModel) {
//        @synchronized(self){
//            baseModel = [[BaseModel alloc]init];
//        }
//    }
//    return baseModel;
//
//}


-(NSDictionary *)allProperties{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithFormat:@"%s",property_getName(property)];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}


-(BOOL) isEqualTo:(BaseModel *) std{
    NSDictionary *selfProperties = [self allProperties];
    NSDictionary *stdProperties = [std allProperties];
    
    return [selfProperties isEqualToDictionary:stdProperties];
    
}


-(BaseModel *)setPropertiesWithDictionary:(NSDictionary *)dictionary{
    if ([NSNull null] == (NSNull *)dictionary) {
        return self;
    }
    NSArray *dicAllKeys = [dictionary allKeys];
    
    NSInteger count = [dicAllKeys count];
    for (int index = 0; index < count; ++index) {
        
        NSString *dicKeyAtIndex = dicAllKeys[index];
        
        NSString *dicValueAtIndex = dictionary[dicKeyAtIndex];
        
        if (![dicValueAtIndex isKindOfClass:[NSString class]]) {
            dicValueAtIndex = [NSString stringWithFormat:@"%@",dicValueAtIndex];
        }else if (dicValueAtIndex.class == [NSNull class]){
            dicValueAtIndex = [NSString stringWithFormat:@"%@",dicValueAtIndex];
        }else if([NSNull null] == (NSNull *)dicValueAtIndex){
            dicValueAtIndex = [NSString stringWithFormat:@"%@",dicValueAtIndex];
        }else if([dicValueAtIndex isKindOfClass:[NSNumber class]]){
            dicValueAtIndex = [NSString stringWithFormat:@"%@",dicValueAtIndex];
        }else if(0x00 == dicValueAtIndex){
            dicValueAtIndex = [NSString stringWithFormat:@"%@",@""];
        }
        //if dickeyAtIndex is a property of self,it must be responde to selector of it
        SEL getKeyMethod = NSSelectorFromString(dicKeyAtIndex);
        if ([self respondsToSelector:getKeyMethod]) {
            [self setValue:dicValueAtIndex forKey:dicKeyAtIndex];
        }
        
    }
    return self;
}

    
    
    
@end

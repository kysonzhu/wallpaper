//
//  KSModel.m
//  BIFCore
//
//  Created by Softwind.Tang on 15/1/7.
//  Copyright (c) 2015年 Plan B Inc. All rights reserved.
//
#import <objc/runtime.h>
#import "KSModel.h"

#define CStringToNSSting(A) [[NSString alloc] initWithCString:(A) encoding:NSUTF8StringEncoding]

@implementation BIFObject

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (NSMutableDictionary *)dictionaryRepresentation
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (int i = 0; i < count; ++ i) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        if ([self respondsToSelector:NSSelectorFromString(key)]) {
            id value = [self valueForKey:key];
            dic[key] = value ? value : @"";
        }
    }
    return dic;
}

#pragma clang diagnostic pop

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
}

@end

NSString * const kKSModelPropertyDefaultValue = @"";

@implementation KSModel

#pragma mark - publics

+ (NSArray *)keyPathInApiResponse
{
    return @[@"items"];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (void)loadPropertiesWithData:(NSDictionary *)data
{
    if (![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    for (NSString *key in [data keyEnumerator]) {
        if ([self respondsToSelector:NSSelectorFromString(key)]) {
            NSString *setter = [NSString stringWithFormat:@"set%@%@:",
                                [[key substringToIndex:1] uppercaseString],
                                [key substringFromIndex:1]];
            NSString *value = data[key];
            if (value == nil || [value isKindOfClass: [NSNull class]] || value == NULL) {
                value = @"";
            }
            [self performSelector:NSSelectorFromString(setter)
                       withObject:value];
        }
    }
}

#pragma clang diagnostic pop

- (NSArray *)loadArrayPropertyWithDataSource:(NSArray *)data requireModel:(NSString *)model
{
    if (![data isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *p = [NSMutableArray array];
    for (NSDictionary *dic in data) {
        KSModel *m = [[NSClassFromString(model) alloc] init];
        if (![m isKindOfClass:[KSModel class]]) {
            return nil;
        }
        [m loadPropertiesWithData:dic];
        [p addObject:m];
    }

    return p;
}

#pragma mark - life cycle

- (instancetype)init
{
    if (self = [super init]) {
        [self resetAllValues];
    }
    
    return self;
}

#pragma mark - dictionaryRepresentation

/**
 *  全反射！
 */
- (NSMutableDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; ++ i) {
        NSString *propertyClassName = [self classNameFromType:CStringToNSSting(property_getAttributes(properties[i]))];
        NSString *propertyName = CStringToNSSting(property_getName(properties[i]));
        
        id propertyValue = [self valueForKey:propertyName];
        
        if (!propertyValue) {
            continue;
        }
        
        //是 KSModel 的子类
        if ([NSClassFromString(propertyClassName) isSubclassOfClass:[KSModel class]]) {
            dic[propertyName] = [propertyValue dictionaryRepresentation];
            continue;
        }
        
        //是数组
        if (NSClassFromString(propertyClassName) == [NSArray class]) {
            NSMutableArray *array = [NSMutableArray array];
            for (KSModel *model in propertyValue) {
                //目前只支持一层数组，若嵌套了两层数组，再贱→_→
                if ([model isKindOfClass:[KSModel class]]) {
                    [array addObject:[model dictionaryRepresentation]];
                } else {
                    [array addObject:model];
                }
            }
            dic[propertyName] = array;
            continue;
        }
        
        //其他情况
        dic[propertyName] = propertyValue;
    }
    
    return dic;
}

#pragma mark - reset values

- (void)resetAllValues
{
    [self resetAllValuesInClass:[self class]];
}

- (void)resetAllValuesInClass:(Class)class
{
    if ([class superclass] != [KSModel class]) {
        [self resetAllValuesInClass:[class superclass]];
    }
    
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(class, &count);
    for (int i = 0; i < count; ++ i) {
        NSString *propertyClassName = [[NSString alloc] initWithCString:property_getAttributes(properties[i])
                                                               encoding:NSUTF8StringEncoding];
        propertyClassName = [self classNameFromType:propertyClassName];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(properties[i])
                                                          encoding:NSUTF8StringEncoding];
        
        if (!propertyClassName) {
            continue;
        }
        
        //是 字符串 （一般属性）
        if ([propertyClassName isEqualToString:@"NSString"]) {
            [self setValue:kKSModelPropertyDefaultValue
                    forKey:propertyName];
            continue;
        }
        
        //是嵌套类
        if ([NSClassFromString(propertyClassName) isSubclassOfClass:[KSModel class]]) {
            KSModel *model = [[NSClassFromString(propertyClassName) alloc] init];
            [self setValue:model
                    forKey:propertyName];
        }
    }
}

- (NSString *)classNameFromType:(NSString *)propertyType
{
    NSArray *array = [propertyType componentsSeparatedByString:@"\""];
    if ([array count] == 3) {
        return array[1];
    } else {
        return nil;
    }
}

@end

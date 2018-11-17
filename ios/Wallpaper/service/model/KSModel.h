//
//  KSModel.h
//  BIFCore
//
//  Created by Softwind.Tang on 15/1/7.
//  Copyright (c) 2015年 Plan B Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@protocol BIFObject <NSObject>

/**
 *  用字典来描述这个类，字典中包含类中的所有属性，以 属性名:属性值 为一个单位。
 *
 *  @return 代表这个类的字典。
 */
- (NSMutableDictionary *)dictionaryRepresentation;

@optional

/**
 *  方法重组，需要的情况下实现
 */
+ (void)swizzleSelector;
@end

@interface BIFObject : NSObject <BIFObject, NSCoding>

@end

/**
 *  创建string类型property的宏定义
 *
 *  @param __NAME__ 需要创建的变量名
 *
 *  @return
 */
#define CREATE_STRING_PROPERTY(__NAME__)\
@property (nonatomic, copy) NSString *__NAME__;


/**
 *  针对model中得对象类型的变量，重写setter方法的宏定义
 *  如果有什么特殊处理请自行重写setter
 *
 *  @param __TYPE__     变量的类型
 *  @param __NAME__     变量名
 *  @param __FUN_NAME__ 变量对应的方法名
 *  示例：SETPROPERTY(FBBlock, block , Block)
 *
 *  @return 变量对应的setter方法
 */
#define SETPROPERTY(__TYPE__, __NAME__, __FUN_NAME__)   \
- (void)set##__FUN_NAME__:(id)__NAME__ \
{ \
    if ([__NAME__ isKindOfClass:[NSDictionary class]]) {   \
        [_##__NAME__ loadPropertiesWithData:__NAME__];  \
    } else if([__NAME__ isKindOfClass:[__TYPE__ class]]){   \
        if (_##__NAME__ != __NAME__){   \
            _##__NAME__ = __NAME__; \
        }   \
    } else if (!__NAME__){   \
        _##__NAME__ = __NAME__; \
    } \
}

/**
 *  针对model中得数组类型的变量(数组中得对象类型为自定义对象类型)，重写setter方法的宏定义
 *  如果有什么特殊处理请自行重写setter
 *
 *  @param __TYPE__     数组中变量的类型
 *  @param __NAME__     变量名
 *  @param __FUN_NAME__ 变量对应的方法名
 *  示例：SETARRAYPROPERTY(FBCommunity, communities, Communities)
 *
 *  @return 变量对应的setter方法
 */
#define SETARRAYPROPERTY(__TYPE__, __NAME__, __FUN_NAME__)  \
- (void)set##__FUN_NAME__:(NSArray *)__NAME__   \
{   \
    if (![__NAME__ isKindOfClass:[NSArray class]]) {   \
        if (!__NAME__){   \
            _##__NAME__ = __NAME__; \
        } \
        return; \
    }   \
    BOOL realAssign = NO;   \
    if (__NAME__.count > 0 && [__NAME__[0] isKindOfClass:[__TYPE__ class]]) {   \
        realAssign = YES;   \
    }   \
    if (!realAssign) {   \
        _##__NAME__ = [self loadArrayPropertyWithDataSource:__NAME__ requireModel:@#__TYPE__];   \
    } else {   \
        if (_##__NAME__ != __NAME__){   \
            _##__NAME__ = __NAME__;   \
        }   \
    }   \
}

extern NSString * const kKSModelPropertyDefaultValue;

/**
 *  数据模型
 *  该类型中的成员变量尽量都转换成：NSString、KSModel、NSArray三种类型
 */
@interface KSModel : BIFObject

/**
 *  在 api 中的路径，返回一个 key 的数据，注意顺序
 */
+ (NSArray *)keyPathInApiResponse;

#pragma mark - 从 api 反序列化

/**
 *  反序列化
 */
- (void)loadPropertiesWithData:(NSDictionary *)data;

/**
 *  为 array 类型的 property 反序列化
 *
 *  @param data  数据源
 *  @param model 数据模型名
 *
 *  @return 序列化后的数据模型数组
 */
- (NSArray *)loadArrayPropertyWithDataSource:(NSArray *)data requireModel:(NSString *)model;

/**
 *  重置所有属性，设为初值。
 *  所有 string 处置为 @""。
 *  其它的如果有，基本上都设为 0/NO
 */
- (void)resetAllValues;

@end

//
//  JsonHandler.m
//  Pitch
//
//  Created by zhujinhui on 14-9-13.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "JsonHandler.h"
#import "NSString+Util.h"
#import "BaseModel.h"
#import "Group.h"

#import "EnvironmentConfigure.h"

@implementation JsonHandler


+(id)convertToObjectWithResponse:(NetworkResponse **)responseAddr{
    NetworkResponse *response = (*responseAddr);
    NSString *jsonString = response.rawJson;
    if (!jsonString) {
        NSLog(@"response raw string is null,what's up?!");
        response.errorCode = 111111;
        response.errorMessage = @"没有返回任何数据";
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    //judge if the raw json is json,if is not json error will not be nil,then return directly
    if (error) {
        response.errorCode = error.code;
        response.errorMessage = @"Json解析异常";
        return nil;
    }
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *jsonDictionary = (NSDictionary *) jsonObject;
        
        //the "integerValue" method can ignore space
        //This property is INT_MAX or INT_MIN on overflow. This property is 0 if the string doesn’t begin with a valid decimal text representation of a number.
        NSInteger errorcode = [jsonDictionary[@"errorCode"] integerValue];
        response.errorCode = errorcode;
        if (0 == errorcode ) {
            NSDictionary *dicResult = jsonDictionary[@"result"];
            
            NSArray *dicAllKeys = [dicResult allKeys];
            NSString *objectString = dicAllKeys[0];//for example:"user" model,but it can be null
            
            NSArray *objectValuesArray = [dicResult allValues];
            //juege if the object is null
            if ([objectValuesArray count] > 0) {
                NSDictionary *objectValue = objectValuesArray[0];
                //the first char should
                objectString = [objectString replaceTheFirstCharacterToUpper];
                Class objectClass = NSClassFromString(objectString);
                if (objectClass) {
                    id objectInstance = [[objectClass alloc]init];
                    BaseModel *instance = (BaseModel *) objectInstance;
                    [instance setPropertiesWithDictionary:objectValue];
                    //get object
                    response.response = instance;
                }else{
                    response.response = nil;
                    response.errorCode = 123456;
                    response.errorMessage = @"解析出错，非法字段!";
                }
                
            }
        }else{
            //get error code and error message
            NSString *errorMsg = jsonDictionary[@"errorMessage"];
            response.errorMessage = errorMsg;
        }
    }
    return response.response;
}


+(NSArray *)convertToListWithResponse:(NetworkResponse **)responseAddr{
    NSMutableArray *returnArray = [[NSMutableArray alloc]init];
    NetworkResponse *response = (*responseAddr);
    NSString *jsonString = response.rawJson;
    if (!jsonString) {
        NSLog(@"response raw string is null,what's up?!");
        response.errorCode = 111111;
        response.errorMessage = @"没有返回任何数据";
        return returnArray;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    //judge if the raw json is json,if is not json error will not be nil,then return directly
    if (error) {
        response.errorCode = error.code;
        response.errorMessage = @"服务器被外星人劫持了";
        return returnArray;
    }
    
    NSDictionary *jsonDictionary = (NSDictionary *) jsonObject;
    
    if ([NSNull null] == (NSNull *)jsonObject) {
        response.errorCode = error.code;
        response.errorMessage = @"服务器被外星人劫持了";
        return returnArray;
    }
    
    //the "integerValue" method can ignore space
    //This property is INT_MAX or INT_MIN on overflow. This property is 0 if the string doesn’t begin with a valid decimal text representation of a number.
    NSInteger errorcode = [jsonDictionary[@"errorCode"] integerValue];
    response.errorCode = errorcode;
    
    if (0 == errorcode ) {
        NSDictionary *dicResult = jsonDictionary[@"result"];
        //get the object
        NSString *jsonResultListKey = [dicResult allKeys][0];
        NSArray *jsonResultListValue = [dicResult objectForKey:jsonResultListKey];
        
        //charge the data is kind of list,if not ,return directly
        if (![jsonResultListKey hasSuffix:@"list"] && ![jsonResultListKey hasSuffix:@"List"]) {
            response.errorCode = error.code;
            response.errorMessage = @"服务器被外星人劫持了";
            return returnArray;
        }else{
            NSRange range=[jsonResultListKey rangeOfString:@"List"];
            NSInteger location = range.location;
            range = (location != NSNotFound) ? range: [jsonResultListKey rangeOfString:@"list"];
            //range.location surely larger than 0
            jsonResultListKey = [jsonResultListKey substringToIndex:range.location];
        }
        
        //the first char should
        NSString *objectString = [jsonResultListKey replaceTheFirstCharacterToUpper];
        Class objectClass = NSClassFromString(objectString);
        if (objectClass) {
            for (NSDictionary *dicItem in jsonResultListValue) {
                //get class and instance
                id objectInstance = [[objectClass alloc]init];
                BaseModel* instance = (BaseModel *) objectInstance;
                // set properties
                [instance setPropertiesWithDictionary:dicItem];
                if ([objectInstance isKindOfClass:[Group class]]) {
                    Group *group =(Group *)instance;
                    if (![[EnvironmentConfigure shareInstance]shouldFilter:group.gName]) {
                        [returnArray addObject:objectInstance];
                    }
                }else{
                    [returnArray addObject:objectInstance];
                }
            }
        }else{
            NSLog(@"kyson:%@:no class:%@ founded",self,objectString);
        }
        //at last , we must set object to networkresponse
        response.response = returnArray;
        
    }else{
        NSLog(@"kyson:no object can get from the list");
    }
    
    return returnArray;
}





+(BOOL)convertToBoolWithResponse:(NetworkResponse **)responseAddr{
    
    NetworkResponse *response = (*responseAddr);
    NSString *jsonString = response.rawJson;
    if (!jsonString) {
        NSLog(@"response raw string is null,what's up?!");
        response.errorCode = 111111;
        response.errorMessage = @"没有返回任何数据";
        return NO;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    //judge if the raw json is json,if is not json error will not be nil,then return directly
    if (error) {
        response.errorCode = error.code;
        response.errorMessage = @"Json解析异常";
        return NO;
    }
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *jsonDictionary = (NSDictionary *) jsonObject;
        
        //the "integerValue" method can ignore space
        //This property is INT_MAX or INT_MIN on overflow. This property is 0 if the string doesn’t begin with a valid decimal text representation of a number.
        NSInteger errorcode = [jsonDictionary[@"errorCode"] integerValue];
        response.errorCode = errorcode;
        if (0 == errorcode ) {
            NSDictionary *dicResult = jsonDictionary[@"result"];
            NSString *isSuccess = dicResult[@"issuccess"];
            response.response = isSuccess ;
            
        }else{
            //get error code and error message
            NSString *errorMsg = jsonDictionary[@"errorMessage"];
            response.errorMessage = errorMsg;
        }
    }
    return NO;
    
}


+(NetworkResponse *)convertToErrorResponse:(NetworkResponse **)responseAddr{
    NetworkResponse *response = (*responseAddr);
    NSString *jsonString = response.rawJson;
    if (!jsonString) {
        NSLog(@"response raw string is null,what's up?!");
        response.errorCode = 111111;
        response.errorMessage = @"没有返回任何数据";
        return response;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    //judge if the raw json is json,if is not json error will not be nil,then return directly
    if (error) {
        response.errorCode = error.code;
        response.errorMessage = @"Json解析异常";
        return response;
    }
    
    
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *jsonDictionary = (NSDictionary *) jsonObject;
        NSInteger errorcode = [jsonDictionary[@"errorCode"] integerValue];
        response.errorCode = errorcode;
        NSString *errorMessage = jsonDictionary[@"errorMessage"];
        response.errorMessage = errorMessage;
    }
    return response;
}


@end

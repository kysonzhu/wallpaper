//
//  JsonHandler.h
//  Pitch
//
//  Created by zhujinhui on 14-9-13.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//
/**
 * kyson tec. we has own json formatter,in a word,2 kinds of condition,3 types of result.
 *  2 kinds of condition:
 *  [1]failed:
 *  json formater should format as:
 *  {
 *    "errorCode": "10001",
 *    "errorMessage": "参数为空！"
 *  }
 *   contains errorCode and errorMessage
 *  [2]success:
 *  3 types of result:
 *  (1)true or false:
 *  json formater should format as:
 *  {
 *    "errorCode": "0",
 *    "result": "1"
 *  }
 *  "1" means success,and 0 means failed
 *  (2)object,for example dologin method and return a object "User"
 *  json formater should format as:
 *  {
 *    "errorCode": "0",
 *    "result": {"user":{"userId":123,"age":"13"}}
 *  }
 *  (3)list,for example we have a list of User to return
 *  json formater should format as:
 *  {
 *    "errorCode": "0",
 *    "result": {"userList":[{"userId":123,"age":"13"},{"userId":123,"age":"13"}]}
 *  }
 *
 *
 *
 */

#import <Foundation/Foundation.h>
#import "NetworkResponse.h"


@interface JsonHandler : NSObject

+(id)convertToObjectWithResponse:(NetworkResponse **)responseAddr;

+(BOOL)convertToBoolWithResponse:(NetworkResponse **)response;

+(NSArray *)convertToListWithResponse:(NetworkResponse **)responseAddr;

+(NetworkResponse *)convertToErrorResponse:(NetworkResponse **)responseAddr;

@end

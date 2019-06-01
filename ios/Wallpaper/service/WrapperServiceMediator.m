
//
//  WrapperServiceMediator.m
//  WallWrapper ( https://github.com/kysonzhu/wallpaper.git )
//
//  Created by zhujinhui on 14-12-27.
//  Copyright (c) 2014年 zhujinhui( http://kyson.cn ). All rights reserved.
//

#import "WrapperServiceMediator.h"
#import <MGNetworkAccess.h>
#import <MGJsonHandler.h>
#import "EnvironmentConfigure.h"
//#define HOST @"http://sj.zol.com.cn:8088"
#define HOST @"http://sj.zol.com.cn"

#define HOST_KYSON @"http://kyson.cn/wallpaper/index.php"

#define SERVICE_METHOD_MAP(__SERVICENAME_,METHODNAME) \
if ([self.serviceName isEqualToString:__SERVICENAME_]) {\
self.methodName = NSStringFromSelector(@selector(METHODNAME));\
}\

@implementation WrapperServiceMediator

#define kWallPaperSourceKyson @"2"
#define kWallPaperSourceXiuXiu @"3"

-(void)main{
    [super main];
}

-(MGNetwokResponse *)getRecommendList{
    MGNetworkAccess *networkAccess = [[MGNetworkAccess alloc] initWithHost:HOST modulePath:nil];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"start"] = self.requestParams[@"start"];
    params[@"end"] = @"30";
    //filter image size
    CGRect rect = [UIScreen mainScreen].bounds;
    NSInteger width = (int) (rect.size.width * 2);
    NSInteger height = (int) (rect.size.height * 2);
    params[@"imgSize"] = [NSString stringWithFormat:@"%lix%li",(long)width,(long)height];
    
    MGNetwokResponse *response = nil;
    
    if (0 == response.errorCode)
    {
//        response = [networkAccess doServiceRequestWithName:SERVICENAME_RECOMMENDEDLIST params:params];
//        [MGJsonHandler convertToErrorResponse:&response];
//
//        if (![EnvironmentConfigure shareInstance].showAllData)
//        {
//            NSMutableArray *babyList = [NSMutableArray arrayWithArray:response.rawResponseDictionary[@"result"][@"groupList"]];
//            response.rawResponseArray = babyList;
//            return response;
//        }
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }

    return response;
}


-(MGNetwokResponse *)getRecommendDetail
{
    
    MGNetworkAccess *networkAccess = [[MGNetworkAccess alloc] initWithHost:HOST modulePath:nil];
    //set params
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"gId"]= self.requestParams[@"gId"];
    //filter image size
    CGRect rect = [UIScreen mainScreen].bounds;
    NSInteger width = (int) (rect.size.width * 2);
    NSInteger height = (int) (rect.size.height * 2);
    
    if (height < 961) {
        width = 320;
        height = 480;
    }else{
        width = 480;
        height = 854;
    }
    params[@"picSize"] = [NSString stringWithFormat:@"%lix%li",(long)width,(long)height];
    MGNetwokResponse *response = [networkAccess doServiceRequestWithName:SERVICENAME_RECOMMENDEDDETAIL params:params];
    if (0 == response.errorCode) {
        [MGJsonHandler convertToErrorResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
}


-(MGNetwokResponse *)getLatestList
{
    //以下来自kyson源
    MGNetworkAccess *networkAccess = [[MGNetworkAccess alloc] initWithHost:HOST_KYSON modulePath:nil];
    MGNetwokResponse *response = [networkAccess doServiceRequestWithName:@"baby" params:nil];
    NSArray *resultArry = response.rawResponseDictionary[@"content"];
    NSMutableArray *array2 = [[NSMutableArray alloc] init];
    for (NSDictionary *dictItem in resultArry)
    {
        NSMutableDictionary *resultDictionary2 = [[NSMutableDictionary alloc] init];
        resultDictionary2[@"coverImgUrl"] = dictItem[@"coverImageUrl"];
        resultDictionary2[@"gName"] = [NSString stringWithFormat:@"%@",dictItem[@"brief"]];
        resultDictionary2[@"id"] = dictItem[@"id"];
        resultDictionary2[@"wallPaperSource"] = kWallPaperSourceKyson;
        resultDictionary2[@"voteGood"] = @"111";
        resultDictionary2[@"editDate"] = @"2018-02-06 13:53:33";
        [array2 addObject:resultDictionary2];
    }
    response.rawResponseArray = array2;
    return response;
}

-(MGNetwokResponse *)getCategoryList
{
    MGNetworkAccess *networkAccess = [[MGNetworkAccess alloc] initWithHost:HOST modulePath:nil];;
    MGNetwokResponse *response = [networkAccess doServiceRequestWithName:SERVICENAME_CATEGORYLIST params:nil];
    if (0 == response.errorCode)
    {
        [MGJsonHandler convertToErrorResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
}

/**
 * Category list
 */
-(MGNetwokResponse *)getCategoryRecommendedList
{
    MGNetworkAccess *networkAccess = [[MGNetworkAccess alloc] initWithHost:HOST modulePath:nil];;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"cateId"] = self.requestParams[@"cateId"];
    params[@"isAttion"] = @"1";
    params[@"start"] = self.requestParams[@"start"];
    params[@"end"] = @"30";
    //filter image size
    CGRect rect = [UIScreen mainScreen].bounds;
    NSInteger width = (int) (rect.size.width * 2);
    NSInteger height = (int) (rect.size.height * 2);
    params[@"imgSize"] = [NSString stringWithFormat:@"%lix%li",(long)width,(long)height];
    MGNetwokResponse *response = [networkAccess doServiceRequestWithName:SERVICENAME_CATEGORYRECOMMENDEDLIST params:params];
    if (0 == response.errorCode) {
        [MGJsonHandler convertToErrorResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
}

-(MGNetwokResponse *)getCategoryLatestList
{
    MGNetworkAccess *networkAccess = [[MGNetworkAccess alloc] initWithHost:HOST modulePath:nil];;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"cateId"]   = self.requestParams[@"cateId"];
    params[@"isNow"]    = @"1";
    params[@"start"]    = self.requestParams[@"start"];
    params[@"end"]      = @"30";
    //filter image size
    CGRect rect     = [UIScreen mainScreen].bounds;
    NSInteger width = (int) (rect.size.width * 2);
    NSInteger height   = (int) (rect.size.height * 2);
    params[@"imgSize"] = [NSString stringWithFormat:@"%lix%li",(long)width,(long)height];
    MGNetwokResponse *response = [networkAccess doServiceRequestWithName:@"corp/bizhiClient/getGroupInfo.php" params:params];
    if (0 == response.errorCode) {
        [MGJsonHandler convertToErrorResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
}

-(MGNetwokResponse *)getCategoryHotestList
{
    MGNetworkAccess *networkAccess  = [[MGNetworkAccess alloc] initWithHost:HOST modulePath:nil];;
    NSMutableDictionary *params     = [[NSMutableDictionary alloc]init];
    params[@"cateId"]   = self.requestParams[@"cateId"];
    params[@"isDown"]   = @"1";
    params[@"start"]    = self.requestParams[@"start"];
    params[@"end"]      = @"30";
    //filter image size
    CGRect rect = [UIScreen mainScreen].bounds;
    NSInteger width = (int) (rect.size.width * 2);
    NSInteger height = (int) (rect.size.height * 2);
    params[@"imgSize"] = [NSString stringWithFormat:@"%lix%li",(long)width,(long)height];
    MGNetwokResponse *response = [networkAccess doServiceRequestWithName:@"corp/bizhiClient/getGroupInfo.php" params:params];
    if (0 == response.errorCode) {
        [MGJsonHandler convertToErrorResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
}

/**
 * Secondary category
 */
-(MGNetwokResponse *)getSecondaryCategoryList
{
    MGNetworkAccess *networkAccess = [[MGNetworkAccess alloc] initWithHost:HOST modulePath:nil];;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"fatherId"] = self.requestParams[@"fatherId"];
    MGNetwokResponse *response = [networkAccess doServiceRequestWithName:@"corp/bizhiClient/getCateInfo.php" params:params];
    if (0 == response.errorCode) {
        [MGJsonHandler convertToErrorResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
}


-(MGNetwokResponse *)getSecondaryCategoryRecommendedList
{
    MGNetworkAccess *networkAccess = [[MGNetworkAccess alloc] initWithHost:HOST modulePath:nil];;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"cateId"] = self.requestParams[@"cateId"];
    params[@"subId"] = self.requestParams[@"subId"];
    params[@"isAttion"] = @"1";
    params[@"start"] = self.requestParams[@"start"];
    params[@"end"] = @"30";
    CGRect rect = [UIScreen mainScreen].bounds;
    NSInteger width = (int) (rect.size.width * 2);
    NSInteger height = (int) (rect.size.height * 2);
    params[@"imgSize"] = [NSString stringWithFormat:@"%lix%li",(long)width,(long)height];
    MGNetwokResponse *response = [networkAccess doServiceRequestWithName:@"corp/bizhiClient/getGroupInfo.php" params:params];
    if (0 == response.errorCode) {
        [MGJsonHandler convertToErrorResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
    
}


-(MGNetwokResponse *)getSecondaryCategoryLatestList
{
    MGNetworkAccess *networkAccess = [[MGNetworkAccess alloc] initWithHost:HOST modulePath:nil];;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"cateId"] = self.requestParams[@"cateId"];
    params[@"subId"] = self.requestParams[@"subId"];
    params[@"isNow"] = @"1";
    params[@"start"] = self.requestParams[@"start"];
    params[@"end"] = @"30";
    CGRect rect = [UIScreen mainScreen].bounds;
    NSInteger width = (int) (rect.size.width * 2);
    NSInteger height = (int) (rect.size.height * 2);
    params[@"imgSize"] = [NSString stringWithFormat:@"%lix%li",(long)width,(long)height];
    MGNetwokResponse *response = [networkAccess doServiceRequestWithName:@"corp/bizhiClient/getGroupInfo.php" params:params];
    if (0 == response.errorCode) {
        [MGJsonHandler convertToErrorResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
    
}

-(MGNetwokResponse *)getSecondaryCategoryHotestList
{
    MGNetworkAccess *networkAccess = [[MGNetworkAccess alloc] initWithHost:HOST modulePath:nil];;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"cateId"] = self.requestParams[@"cateId"];
    params[@"subId"] = self.requestParams[@"subId"];
    params[@"isDown"] = @"1";
    params[@"start"] = self.requestParams[@"start"];
    params[@"end"] = @"30";
    CGRect rect = [UIScreen mainScreen].bounds;
    NSInteger width = (int) (rect.size.width * 2);
    NSInteger height = (int) (rect.size.height * 2);
    params[@"imgSize"] = [NSString stringWithFormat:@"%lix%li",(long)width,(long)height];
    MGNetwokResponse *response = [networkAccess doServiceRequestWithName:@"corp/bizhiClient/getGroupInfo.php" params:params];
    if (0 == response.errorCode) {
        [MGJsonHandler convertToErrorResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
}

-(MGNetwokResponse *)getSearchResultList
{
    MGNetworkAccess *networkAccess = [[MGNetworkAccess alloc] initWithHost:HOST modulePath:nil];;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"wd"] = self.requestParams[@"word"];
    params[@"start"] = self.requestParams[@"start"];
    params[@"end"] = @"30";
    MGNetwokResponse *response = [networkAccess doServiceRequestWithName:@"corp/bizhiClient/getSearchInfo.php" params:params];
    if (0 == response.errorCode) {
        [MGJsonHandler convertToErrorResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
}

-(MGNetwokResponse *)appConfig
{
    MGNetworkAccess *networkAccess = [[MGNetworkAccess alloc] initWithHost:HOST_KYSON modulePath:nil];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    MGNetwokResponse *response = [networkAccess doServiceRequestWithName:SERVICENAME_APPCONFIG params:params];
    if (0 == response.errorCode) {
        [MGJsonHandler convertToErrorResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
}


-(void)setServiceName:(NSString *)serviceName
{
    super.serviceName = serviceName;

    SERVICE_METHOD_MAP(SERVICENAME_RECOMMENDEDDETAIL,getRecommendDetail)

    SERVICE_METHOD_MAP(SERVICENAME_CATEGORYLIST,getCategoryList)
    SERVICE_METHOD_MAP(SERVICENAME_CATEGORYRECOMMENDEDLIST,getCategoryRecommendedList)
    SERVICE_METHOD_MAP(SERVICENAME_CATEGORYLATESTLIST,getCategoryLatestList)
    SERVICE_METHOD_MAP(SERVICENAME_CATEGORYHOTESTLIST,getCategoryHotestList)
    SERVICE_METHOD_MAP(SERVICENAME_CATEGORYSECONDARY,getSecondaryCategoryList)
    SERVICE_METHOD_MAP(SERVICENAME_SECONDARYCATEGORYRECOMMENDEDLIST,getSecondaryCategoryRecommendedList)
    SERVICE_METHOD_MAP(SERVICENAME_SECONDARYCATEGORYLATESTLIST,getSecondaryCategoryLatestList)
    SERVICE_METHOD_MAP(SERVICENAME_SECONDARYCATEGORYHOTESTLIST,getSecondaryCategoryHotestList)
    SERVICE_METHOD_MAP(SERVICENAME_SEARCHGETSEARCHRESULTLIST,getSearchResultList)
    SERVICE_METHOD_MAP(SERVICENAME_APPCONFIG,appConfig)
}


@end

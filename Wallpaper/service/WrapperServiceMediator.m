
//
//  WrapperServiceMediator.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-27.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "WrapperServiceMediator.h"
#import <MGNetworkAccess.h>
#import <MGJsonHandler.h>

//#define HOST @"http://sj.zol.com.cn:8088"
#define HOST @"http://sj.zol.com.cn"

@implementation WrapperServiceMediator

-(void)main{
    [super main];
}

-(MGNetwokResponse *)getRecommendList:(NSString *)start{
    MGNetworkAccess *networkAccess = [[MGNetworkAccess alloc] initWithHost:HOST modulePath:nil];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    if (nil != start) {
        params[@"start"] = start;
    }
    params[@"end"] = @"30";
    //filter image size
    CGRect rect = [UIScreen mainScreen].bounds;
    NSInteger width = (int) (rect.size.width * 2);
    NSInteger height = (int) (rect.size.height * 2);
    params[@"imgSize"] = [NSString stringWithFormat:@"%lix%li",(long)width,(long)height];
    
    MGNetwokResponse *response = [networkAccess doServiceRequestWithName:SERVICENAME_RECOMMENDEDLIST params:params];
    if (0 == response.errorCode) {
        [MGJsonHandler convertToErrorResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
}


-(MGNetwokResponse *)getRecommendDetail:(NSString *)gId{
    MGNetworkAccess *networkAccess = [[MGNetworkAccess alloc] initWithHost:HOST modulePath:nil];;
    //set params
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"gId"]=gId;
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


-(MGNetwokResponse *)getLatestList:(NSString *)start{
    MGNetworkAccess *networkAccess = [[MGNetworkAccess alloc] initWithHost:HOST modulePath:nil];;
    //set params
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"start"] = start;
    params[@"end"] = @"30";
    //filter image size
    CGRect rect = [UIScreen mainScreen].bounds;
    NSInteger width = (int) (rect.size.width * 2);
    NSInteger height = (int) (rect.size.height * 2);
    params[@"imgSize"] = [NSString stringWithFormat:@"%lix%li",(long)width,(long)height];
    MGNetwokResponse *response = [networkAccess doServiceRequestWithName:SERVICENAME_LATESTLIST params:params];
    if (0 == response.errorCode) {
        [MGJsonHandler convertToErrorResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
}

-(MGNetwokResponse *)getCategoryList{
    MGNetworkAccess *networkAccess = [[MGNetworkAccess alloc] initWithHost:HOST modulePath:nil];;
    MGNetwokResponse *response = [networkAccess doServiceRequestWithName:SERVICENAME_CATEGORYLIST params:nil];
    if (0 == response.errorCode) {
        [MGJsonHandler convertToErrorResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
}

/**
 * Category list
 */
-(MGNetwokResponse *)getCategoryRecommendedList:(NSString *)cateId :(NSString *)start{
    MGNetworkAccess *networkAccess = [[MGNetworkAccess alloc] initWithHost:HOST modulePath:nil];;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"cateId"] = cateId;
    params[@"isAttion"] = @"1";
    if (nil != start) {
        params[@"start"] = start;
    }
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

-(MGNetwokResponse *)getCategoryLatestList:(NSString *)cateId :(NSString *)start{
    MGNetworkAccess *networkAccess = [[MGNetworkAccess alloc] initWithHost:HOST modulePath:nil];;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"cateId"]   = cateId;
    params[@"isNow"]    = @"1";
    params[@"start"]    = start;
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

-(MGNetwokResponse *)getCategoryHotestList:(NSString *)cateId :(NSString *)start{
    MGNetworkAccess *networkAccess  = [[MGNetworkAccess alloc] initWithHost:HOST modulePath:nil];;
    NSMutableDictionary *params     = [[NSMutableDictionary alloc]init];
    params[@"cateId"]   = cateId;
    params[@"isDown"]   = @"1";
    params[@"start"]    = start;
    params[@"end"]      = @"30";
    //filter image size
    CGRect rect = [UIScreen mainScreen].bounds;
    NSInteger width = (int) (rect.size.width * 2);
    NSInteger height = (int) (rect.size.height * 2);
    params[@"imgSize"] = [NSString stringWithFormat:@"%lix%li",(long)width,(long)height];
//    NetworkResponse *response = [networkAccess doHttpRequest:@"corp/bizhiClient/getGroupInfo.php" params:params];
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
-(MGNetwokResponse *)getSecondaryCategoryList:(NSString *)fatherId{
    MGNetworkAccess *networkAccess = [[MGNetworkAccess alloc] initWithHost:HOST modulePath:nil];;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"fatherId"] = fatherId;
    MGNetwokResponse *response = [networkAccess doServiceRequestWithName:@"corp/bizhiClient/getCateInfo.php" params:params];
    if (0 == response.errorCode) {
        [MGJsonHandler convertToErrorResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
}


-(MGNetwokResponse *)getSecondaryCategoryRecommendedList:(NSString *)cateId :(NSString *)subId :(NSString *)start{
    MGNetworkAccess *networkAccess = [[MGNetworkAccess alloc] initWithHost:HOST modulePath:nil];;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"cateId"] = cateId;
    params[@"subId"] = subId;
    params[@"isAttion"] = @"1";
    params[@"start"] = start;
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


-(MGNetwokResponse *)getSecondaryCategoryLatestList:(NSString *)cateId :(NSString*) subId :(NSString *)start{
    MGNetworkAccess *networkAccess = [[MGNetworkAccess alloc] initWithHost:HOST modulePath:nil];;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"cateId"] = cateId;
    params[@"subId"] = subId;
    params[@"isNow"] = @"1";
    params[@"start"] = start;
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

-(MGNetwokResponse *)getSecondaryCategoryHotestList:(NSString *)cateId :(NSString *)subId :(NSString *)start{
    MGNetworkAccess *networkAccess = [[MGNetworkAccess alloc] initWithHost:HOST modulePath:nil];;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"cateId"] = cateId;
    params[@"subId"] = subId;
    params[@"isDown"] = @"1";
    params[@"start"] = start;
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

-(MGNetwokResponse *)getSearchResultList:(NSString *)word :(NSString *)start{
    MGNetworkAccess *networkAccess = [[MGNetworkAccess alloc] initWithHost:HOST modulePath:nil];;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"wd"] = word;
    params[@"start"] = start;
    params[@"end"] = @"30";
    MGNetwokResponse *response = [networkAccess doServiceRequestWithName:@"corp/bizhiClient/getSearchInfo.php" params:params];
    if (0 == response.errorCode) {
        [MGJsonHandler convertToErrorResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
}


-(void)setServiceName:(NSString *)serviceName{
    super.serviceName = serviceName;
    if ([self.serviceName isEqualToString:SERVICENAME_RECOMMENDEDLIST]) {
        self.methodName = NSStringFromSelector(@selector(getRecommendList:));
        self.paramNames = [NSArray arrayWithObjects:@"start", nil];
    }else if ([self.serviceName isEqualToString:SERVICENAME_RECOMMENDEDDETAIL]) {
            self.methodName = NSStringFromSelector(@selector(getRecommendDetail:));
            self.paramNames = [NSArray arrayWithObjects:@"gId", nil];
    }else if ([self.serviceName isEqualToString:SERVICENAME_LATESTLIST]){
        self.methodName = NSStringFromSelector(@selector(getLatestList:));
        self.paramNames = [NSArray arrayWithObjects:@"start", nil];
    }else if ([self.serviceName isEqualToString:SERVICENAME_CATEGORYLIST]){
        self.methodName = NSStringFromSelector(@selector(getCategoryList));
    }else if ([self.serviceName isEqualToString:SERVICENAME_CATEGORYRECOMMENDEDLIST]){
        self.methodName = NSStringFromSelector(@selector(getCategoryRecommendedList::));
        self.paramNames = [NSArray arrayWithObjects:@"cateId",@"start", nil];
    }else if ([self.serviceName isEqualToString:SERVICENAME_CATEGORYLATESTLIST]){
        self.methodName = NSStringFromSelector(@selector(getCategoryLatestList::));
        self.paramNames = [NSArray arrayWithObjects:@"cateId",@"start", nil];
    }else if ([self.serviceName isEqualToString:SERVICENAME_CATEGORYHOTESTLIST]){
        self.methodName = NSStringFromSelector(@selector(getCategoryHotestList::));
        self.paramNames = [NSArray arrayWithObjects:@"cateId",@"start", nil];
    }else if ([self.serviceName isEqualToString:SERVICENAME_CATEGORYSECONDARY]){
        self.methodName = NSStringFromSelector(@selector(getSecondaryCategoryList:));
        self.paramNames = [NSArray arrayWithObjects:@"fatherId", nil];
    }else if ([self.serviceName isEqualToString:SERVICENAME_SECONDARYCATEGORYRECOMMENDEDLIST]){
        self.methodName = NSStringFromSelector(@selector(getSecondaryCategoryRecommendedList:::));
        self.paramNames = [NSArray arrayWithObjects:@"cateId",@"subId",@"start", nil];
    }else if ([self.serviceName isEqualToString:SERVICENAME_SECONDARYCATEGORYLATESTLIST]){
        self.methodName = NSStringFromSelector(@selector(getSecondaryCategoryLatestList:::));
        self.paramNames = [NSArray arrayWithObjects:@"cateId",@"subId",@"start", nil];
    }else if ([self.serviceName isEqualToString:SERVICENAME_SECONDARYCATEGORYHOTESTLIST]){
        self.methodName = NSStringFromSelector(@selector(getSecondaryCategoryHotestList:::));
        self.paramNames = [NSArray arrayWithObjects:@"cateId",@"subId",@"start", nil];
    }else if ([self.serviceName isEqualToString:SERVICENAME_SEARCHGETSEARCHRESULTLIST]){
        self.methodName = NSStringFromSelector(@selector(getSearchResultList::));
        self.paramNames = [NSArray arrayWithObjects:@"word",@"start", nil];
    }
    
}


@end

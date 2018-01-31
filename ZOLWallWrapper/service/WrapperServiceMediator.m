
//
//  WrapperServiceMediator.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-27.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "WrapperServiceMediator.h"
#import "NetworkAccess.h"

//#define HOST @"http://sj.zol.com.cn:8088"
#define HOST @"http://sj.zol.com.cn"

@implementation WrapperServiceMediator


-(void)main{
    [super main];
}

-(NetworkResponse *)getRecommendList:(NSString *)start{
    NetworkAccess *networkAccess = [[NetworkAccess alloc]init];
    networkAccess.host = HOST;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
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
    
    NetworkResponse *response = [networkAccess doHttpRequest:@"corp/bizhiClient/getGroupInfo.php" params:params];
    if (0 == response.errorCode) {
        [JsonHandler convertToListWithResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
}


-(NetworkResponse *)getRecommendDetail:(NSString *)gId{
    NetworkAccess *networkAccess = [[NetworkAccess alloc]init];
    networkAccess.host = HOST;
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
    
    NetworkResponse *response = [networkAccess doHttpRequest:@"corp/bizhiClient/getGroupPic.php" params:params];
    
    if (0 == response.errorCode) {
        [JsonHandler convertToListWithResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
}


-(NetworkResponse *)getLatestList:(NSString *)start{
    NetworkAccess *networkAccess = [[NetworkAccess alloc]init];
    networkAccess.host = HOST;
    //set params
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"isNow"] = @"1";
    params[@"start"] = start;
    params[@"end"] = @"30";
    
    //filter image size
    CGRect rect = [UIScreen mainScreen].bounds;
    NSInteger width = (int) (rect.size.width * 2);
    NSInteger height = (int) (rect.size.height * 2);
    params[@"imgSize"] = [NSString stringWithFormat:@"%lix%li",(long)width,(long)height];
    
    NetworkResponse *response = [networkAccess doHttpRequest:@"corp/bizhiClient/getGroupInfo.php" params:params];
    
    if (0 == response.errorCode) {
        [JsonHandler convertToListWithResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
}

-(NetworkResponse *)getCategoryList{
    NetworkAccess *networkAccess = [[NetworkAccess alloc]init];
    networkAccess.host = HOST;
    NetworkResponse *response = [networkAccess doHttpRequest:@"corp/bizhiClient/getCateInfo.php" params:nil];
    if (0 == response.errorCode) {
        [JsonHandler convertToListWithResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
}

/**
 * Category list
 */
-(NetworkResponse *)getCategoryRecommendedList:(NSString *)cateId :(NSString *)start{
    NetworkAccess *networkAccess = [[NetworkAccess alloc]init];
    networkAccess.host = HOST;
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
    
    NetworkResponse *response = [networkAccess doHttpRequest:@"corp/bizhiClient/getGroupInfo.php" params:params];
    if (0 == response.errorCode) {
        [JsonHandler convertToListWithResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
}


-(NetworkResponse *)getCategoryLatestList:(NSString *)cateId :(NSString *)start{
    NetworkAccess *networkAccess = [[NetworkAccess alloc]init];
    networkAccess.host = HOST;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"cateId"] = cateId;
    params[@"isNow"] = @"1";
    params[@"start"] = start;
    params[@"end"] = @"30";
    
    //filter image size
    CGRect rect = [UIScreen mainScreen].bounds;
    NSInteger width = (int) (rect.size.width * 2);
    NSInteger height = (int) (rect.size.height * 2);
    params[@"imgSize"] = [NSString stringWithFormat:@"%lix%li",(long)width,(long)height];
    
    NetworkResponse *response = [networkAccess doHttpRequest:@"corp/bizhiClient/getGroupInfo.php" params:params];
    if (0 == response.errorCode) {
        [JsonHandler convertToListWithResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
    
}

-(NetworkResponse *)getCategoryHotestList:(NSString *)cateId :(NSString *)start{
    NetworkAccess *networkAccess = [[NetworkAccess alloc]init];
    networkAccess.host = HOST;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"cateId"] = cateId;
    params[@"isDown"] = @"1";
    params[@"start"] = start;
    params[@"end"] = @"30";
    
    //filter image size
    CGRect rect = [UIScreen mainScreen].bounds;
    NSInteger width = (int) (rect.size.width * 2);
    NSInteger height = (int) (rect.size.height * 2);
    params[@"imgSize"] = [NSString stringWithFormat:@"%lix%li",(long)width,(long)height];
    
    NetworkResponse *response = [networkAccess doHttpRequest:@"corp/bizhiClient/getGroupInfo.php" params:params];
    if (0 == response.errorCode) {
        [JsonHandler convertToListWithResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
}

/**
 * Secondary category
 */
-(NetworkResponse *)getSecondaryCategoryList:(NSString *)fatherId{
    NetworkAccess *networkAccess = [[NetworkAccess alloc]init];
    networkAccess.host = HOST;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"fatherId"] = fatherId;
    NetworkResponse *response = [networkAccess doHttpRequest:@"corp/bizhiClient/getCateInfo.php" params:params];
    if (0 == response.errorCode) {
        [JsonHandler convertToListWithResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
}


-(NetworkResponse *)getSecondaryCategoryRecommendedList:(NSString *)cateId :(NSString *)subId :(NSString *)start{
    NetworkAccess *networkAccess = [[NetworkAccess alloc]init];
    networkAccess.host = HOST;
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
    
    NetworkResponse *response = [networkAccess doHttpRequest:@"corp/bizhiClient/getGroupInfo.php" params:params];
    if (0 == response.errorCode) {
        [JsonHandler convertToListWithResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
    
}


-(NetworkResponse *)getSecondaryCategoryLatestList:(NSString *)cateId :(NSString*) subId :(NSString *)start{
    NetworkAccess *networkAccess = [[NetworkAccess alloc]init];
    networkAccess.host = HOST;
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
    
    NetworkResponse *response = [networkAccess doHttpRequest:@"corp/bizhiClient/getGroupInfo.php" params:params];
    if (0 == response.errorCode) {
        [JsonHandler convertToListWithResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
    
}

-(NetworkResponse *)getSecondaryCategoryHotestList:(NSString *)cateId :(NSString *)subId :(NSString *)start{
    NetworkAccess *networkAccess = [[NetworkAccess alloc]init];
    networkAccess.host = HOST;
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
    
    NetworkResponse *response = [networkAccess doHttpRequest:@"corp/bizhiClient/getGroupInfo.php" params:params];
    if (0 == response.errorCode) {
        [JsonHandler convertToListWithResponse:&response];
    }else{
        NSLog(@"error message:%@",response.errorMessage);
    }
    return response;
}

-(NetworkResponse *)getSearchResultList:(NSString *)word :(NSString *)start{
    NetworkAccess *networkAccess = [[NetworkAccess alloc]init];
    networkAccess.host = HOST;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"wd"] = word;
    params[@"start"] = start;
    params[@"end"] = @"30";
    NetworkResponse *response = [networkAccess doHttpRequest:@"corp/bizhiClient/getSearchInfo.php" params:params];
    if (0 == response.errorCode) {
        [JsonHandler convertToListWithResponse:&response];
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

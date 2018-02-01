//
//  UserCenter.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 15-1-4.
//  Copyright (c) 2015年 zhujinhui. All rights reserved.
//

#import "UserCenter.h"

#define DATA_SEARCHHISTORY @"DATA_SEARCHHISTORY"
#define DATA_PRAISEDATA    @"DATA_PRAISEDATA"

static UserCenter *usercenter = nil;

@implementation UserCenter


+(UserCenter *)shareInstance{
    if (nil == usercenter) {
        @synchronized(self){
            usercenter = [[UserCenter alloc]init];

        }
    }
    return usercenter;
}

-(NSArray *)getSearchHistoryData{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *data = [userDefaults objectForKey:DATA_SEARCHHISTORY];
    return data;
}

-(void)addSearchHistoryData:(NSString *) latestData{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *data = [userDefaults objectForKey:DATA_SEARCHHISTORY];
    data = nil == data ? [[NSArray alloc]init] : data;
    BOOL hasLatestData = NO;
    for (NSString *dataItem in data) {
        if ([dataItem isEqualToString:latestData]) {
            hasLatestData = YES ;
            break;
        }
    }
    if (!hasLatestData) {
        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:data];
        [array insertObject:latestData atIndex:0];
        //set new info
        [userDefaults setObject:array forKey:DATA_SEARCHHISTORY];
    }else{
        NSLog(@"kyson:%@ nothing to add",self);
    }
    
}

-(void )clearSearchHistoryData{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:DATA_SEARCHHISTORY];
}


-(UIColor *)getRandomColor{
    static NSInteger index = 0;
    UIColor *color = nil;
    switch (index) {
        case 0:{
            color = [UIColor colorWithHex:0xb4cdd1];
        }
            break;
        case 1:{
            color = [UIColor colorWithHex:0xe8cbd1];
        }
            break;
        case 2:{
            color = [UIColor colorWithHex:0xb7a9c0];
        }
            break;
        case 3:{
            color = [UIColor colorWithHex:0xe7e5d2];
        }
            break;
        case 4:{
            color = [UIColor colorWithHex:0xdccddb];
        }
            break;
        case 5:{
            color = [UIColor colorWithHex:0xe5bec7];
        }
            break;
        case 6:{
            color = [UIColor colorWithHex:0xecbbab];
        }
            break;
        case 7:{
            color = [UIColor colorWithHex:0xf2dfdd];
        }
            break;
            
        default:{
            index = 0;
            color = [self getRandomColor];
        }
            break;
    }
    ++index;
    return color;
}


/**
 * add praise data
 */
-(void) addPraiseData:(NSString *)groupId{
    if (nil == groupId) {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *data = [userDefaults objectForKey:DATA_PRAISEDATA];
    data = nil == data ? [[NSArray alloc]init] : data;
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:data];
    [array addObject:groupId];
    //set new info
    [userDefaults setObject:array forKey:DATA_PRAISEDATA];
}
/**
 * check if group is praised
 */
-(BOOL) isPraised:(NSString *)groupId{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *data = [userDefaults objectForKey:DATA_PRAISEDATA];
    BOOL hasLatestData = NO;
    for (NSString *dataItem in data) {
        if ([dataItem isEqualToString:groupId]) {
            hasLatestData = YES ;
            break;
        }
    }
    return hasLatestData;
}



@end

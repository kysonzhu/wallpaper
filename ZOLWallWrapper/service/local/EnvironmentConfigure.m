//
//  EnvironmentConfigure.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 15/1/19.
//  Copyright (c) 2015年 zhujinhui. All rights reserved.
//

#import "EnvironmentConfigure.h"
#define SHOW_ALL_DATA @"SHOW_ALL_DATA"
#define SHOW_ALL_DATA_YES @"SHOW_ALL_DATA_YES"
#define SHOW_ALL_DATA_NO @"SHOW_ALL_DATA_NO"

static EnvironmentConfigure *environmentConfigure = nil;

@implementation EnvironmentConfigure

+(EnvironmentConfigure *)shareInstance{
    @synchronized(self){
        if (nil == environmentConfigure) {
            environmentConfigure = [[EnvironmentConfigure alloc]init];
            [environmentConfigure setShowAllData:NO];
        }
    }
    
    return environmentConfigure;
}

-(BOOL)showAllData{
    BOOL showAllData = NO;
    NSString *show = [[NSUserDefaults standardUserDefaults] objectForKey:SHOW_ALL_DATA];
    if ([show isEqualToString:SHOW_ALL_DATA_NO]) {
        showAllData = NO;
    }else if ([show isEqualToString:SHOW_ALL_DATA_YES]){
        showAllData = YES;
    }
    return showAllData;
}

-(void)setShowAllData:(BOOL)showAllData{
    if (showAllData) {
        [[NSUserDefaults standardUserDefaults] setObject:SHOW_ALL_DATA_YES forKey:SHOW_ALL_DATA];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:SHOW_ALL_DATA_NO forKey:SHOW_ALL_DATA];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(BOOL) shouldFilter:(NSString *) gName{
    if (self.showAllData) {
        return NO;
    }
    BOOL shouldFilter = NO;
    NSArray  *filterStringArray = [[NSArray alloc]initWithObjects:@"性感",@"写真",@"唯美",@"清纯",@"车模",@"美女",@"模特",@"清新",@"cosplay",@"可爱",@"china joy",@"show girl",@"泳衣",@"萌",@"丰满",@"尤物",@"比基尼",@"女孩",@"巨星",@"诱惑",@"巨乳",@"宅男",@"惠特莉",@"组合",@"魔鬼身材",@"时尚女王",@"内衣",@"妖娆",@"超模",@"私房",@"波神",@"宝贝",@"情",@"妖艳",@"徐立",@"女友", nil];
    for (NSString *filterItem in filterStringArray) {
        if (NSNotFound != [gName rangeOfString:filterItem].location) {
            shouldFilter = YES;
            break;
        }
    }
    
    return shouldFilter;
}





@end

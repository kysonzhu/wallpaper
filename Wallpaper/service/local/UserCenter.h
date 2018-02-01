//
//  UserCenter.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 15-1-4.
//  Copyright (c) 2015年 zhujinhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCenter : NSObject

+(UserCenter *)shareInstance;


-(NSArray *)getSearchHistoryData;
/**
 * add search Histroy data to serach view controller
 */
-(void)addSearchHistoryData:(NSString *) latestData;

-(UIColor *)getRandomColor;

-(void )clearSearchHistoryData;
/**
 * add praise data
 */
-(void) addPraiseData:(NSString *)groupId;
/**
 * check if group is praised
 */
-(BOOL) isPraised:(NSString *)groupId;

@end

//
//  NSString+Util.h
//  Pitch
//
//  Created by zhujinhui on 14-9-13.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString(util)

/**
 * get number of how many sub string
 */
-(NSInteger)containsHowMany:(NSString *)subString;

-(NSString *)replaceTheFirstCharacterToUpper;

-(NSString *) yyyyMMddHHmmssToyyyy_MM_dd;

-(NSString *) yyyyMMddToyyyy_MM_dd;

-(NSString *)yyyy_MM_ddToyyyyMMddHHmmss;

-(NSString *)yyyy_MM_ddHHmmssToyyyyMMddHHmmss;

- (NSString *)md5;


@end

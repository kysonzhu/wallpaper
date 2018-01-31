//
//  NSString+Util.m
//  Pitch
//
//  Created by zhujinhui on 14-9-13.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "NSString+Util.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access


@implementation NSString(util)


-(NSInteger)containsHowMany:(NSString *)subString{
    NSInteger subCount = 0;
    NSInteger length = self.length;
    for (int i = 0; length; ++ i) {
        NSString *tempStr = [self substringWithRange:NSMakeRange(i, 1)];
        NSLog(@"the index %i of the string is:%@",i,tempStr);
        if ([tempStr isEqual:@":"]) {
            subCount ++;
        }else{
            NSLog(@"the index %i of the string is not %@",i,subString);
        }
        
    }
    return subCount;
}


-(NSString *)replaceTheFirstCharacterToUpper{
    NSMutableString *tempMString = [[NSMutableString alloc]initWithString:self];
//    NSInteger length = tempMString 
    NSString *firstCharacter = [tempMString substringToIndex:1];
    NSString *firstCharacterUpper = [firstCharacter uppercaseString];
    [tempMString replaceCharactersInRange:NSMakeRange(0, 1) withString:firstCharacterUpper];
    return tempMString;
    
}


-(NSString *) yyyyMMddHHmmssToyyyy_MM_dd{
    
    NSDateFormatter *formater1 = [[NSDateFormatter alloc]init];
    [formater1 setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *time2 = [formater1 dateFromString:self];
    
    NSDateFormatter *formanter2 = [[NSDateFormatter alloc]init];
    [formanter2 setDateFormat:@"yyyy-MM-dd"];
    NSString *time3 = [formanter2 stringFromDate:time2];
    return time3;
    
}

-(NSString *) yyyyMMddToyyyy_MM_dd{
    
    NSDateFormatter *formater1 = [[NSDateFormatter alloc]init];
    [formater1 setDateFormat:@"yyyyMMdd"];
    NSDate *time2 = [formater1 dateFromString:self];
    
    NSDateFormatter *formanter2 = [[NSDateFormatter alloc]init];
    [formanter2 setDateFormat:@"yyyy-MM-dd"];
    NSString *time3 = [formanter2 stringFromDate:time2];
    return time3;
    
}

-(NSString *)yyyy_MM_ddToyyyyMMddHHmmss{
    NSDateFormatter *formater1 = [[NSDateFormatter alloc]init];
    [formater1 setDateFormat:@"yyyy-MM-dd"];
    
    NSDateFormatter *formater2 = [[NSDateFormatter alloc]init];
    [formater2 setDateFormat:@"yyyyMMddHHmmss"];
    
    NSDate *time2 = [formater1 dateFromString:self];
    
    NSString *time3 = [formater2 stringFromDate:time2];

    return time3;
}


-(NSString *)yyyy_MM_ddHHmmssToyyyyMMddHHmmss{
    NSDateFormatter *formater1 = [[NSDateFormatter alloc]init];
    [formater1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDateFormatter *formater2 = [[NSDateFormatter alloc]init];
    [formater2 setDateFormat:@"yyyyMMddHHmmss"];
    
    NSDate *time2 = [formater1 dateFromString:self];
    
    NSString *time3 = [formater2 stringFromDate:time2];
    
    return time3;
}





- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int) strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}


@end

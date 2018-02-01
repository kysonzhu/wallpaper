//
//  FileManager.h
//  Pitch
//
//  Created by zhujinhui on 14-9-7.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _DirectoryType{
    DirectoryTypeDocument,
    
}DirectoryType;

@interface FileManager : NSObject

/**
 * document dir
 */
+(NSString *)documentDir;


/**
 * home dir,sand box dir
 */
+(NSString *)homeDir;

/**
 * resource file
 */
+(NSString *)resourceWithFileName:(NSString *)name
                             type:(NSString *)type;

+(NSString *)generateFilePath:(NSString *) fileName toDirectory:(DirectoryType) type;

+(BOOL)writeFile:(NSString *)fileName toDirectory:(DirectoryType) type withData:(NSData *)data;

+(BOOL)isFileExists:(NSString *)fileName type:(DirectoryType) type;

+(NSData *)getFileWithName:(NSString *)fileName type:(DirectoryType )type;

+(BOOL)removeAllFileAtDirectory:(DirectoryType) type;

/**
 * size of folder ,unit is MB
 */
+ (float )folderSizeAtDirectionary:(DirectoryType) type;

@end

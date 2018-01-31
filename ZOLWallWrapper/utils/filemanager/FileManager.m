//
//  FileManager.m
//  Pitch
//
//  Created by zhujinhui on 14-9-7.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager



+(NSString *)documentDir{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
//    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
    return documents;
}


+(NSString *)homeDir{
    NSString *homeDir = NSHomeDirectory();
    return homeDir;
}

+(NSString *)resourceWithFileName:(NSString *)name
                             type:(NSString *)type{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    return imagePath;

}

+(NSString *)generateFilePath:(NSString *) fileName toDirectory:(DirectoryType) type{
    NSString *filePath = nil;
    switch (type) {
        case DirectoryTypeDocument:{
            NSString *documentDir = [FileManager documentDir];
            filePath = [documentDir stringByAppendingPathComponent:fileName];
        }
            break;
            
        default:
            break;
    }
    return filePath;
}


+(BOOL)writeFile:(NSString *)fileName toDirectory:(DirectoryType) type withData:(NSData *)data{
    BOOL result = NO;
    NSString *path = [FileManager generateFilePath:fileName toDirectory:type];
    if (path) {
        NSError *error = nil;
        result = [data writeToFile:path options:NSDataWritingWithoutOverwriting error:&error];
        if (NO == result) {
            NSLog(@"write failed!,error:%@",error);
        }
    }
    
    return result;
}

+(BOOL)isFileExists:(NSString *)fileName type:(DirectoryType) type{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [FileManager generateFilePath:fileName toDirectory:type];
    return [manager fileExistsAtPath:path];
}


+(NSData *)getFileWithName:(NSString *)fileName type:(DirectoryType )type{
    NSString *path = [FileManager generateFilePath:fileName toDirectory:type];
    NSData* fileData = [NSData dataWithContentsOfFile:path];
    return fileData;

}

+(BOOL)removeAllFileAtDirectory:(DirectoryType) type{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *documentDir = [FileManager documentDir];
    
    NSArray *contents = [manager contentsOfDirectoryAtPath:documentDir error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    BOOL hasError = NO;
    int errorCount = 0;
    while ((filename = [e nextObject])) {
        NSError *error = nil;
        [manager removeItemAtPath:[documentDir stringByAppendingPathComponent:filename] error:&error];
        if (error) {
            hasError = YES;
            ++errorCount;
        }
    }
    if (errorCount < 5) {
        hasError = NO;
    }
    return !hasError;
}

//get directionary size
+ (float ) folderSizeAtDirectionary:(DirectoryType) type{
    NSString *documentDir = [FileManager documentDir];

    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:documentDir]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:documentDir] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [documentDir stringByAppendingPathComponent:fileName];
//        if ([fileAbsolutePath hasSuffix:@"_low"]) {
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
//        }
    }
    return folderSize/(1024.0*1024.0);
}

//单个文件的大小
+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}


@end

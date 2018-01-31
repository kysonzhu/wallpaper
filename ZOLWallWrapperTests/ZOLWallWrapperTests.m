//
//  ZOLWallWrapperTests.m
//  ZOLWallWrapperTests
//
//  Created by zhujinhui on 14-12-9.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FileManager.h"

@interface ZOLWallWrapperTests : XCTestCase

@end

@implementation ZOLWallWrapperTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}


- (void) testFileManager {
    NSData *data = [[NSData alloc]init];
    
    [FileManager writeFile:@"aaa" toDirectory:DirectoryTypeDocument withData:data];
}

@end

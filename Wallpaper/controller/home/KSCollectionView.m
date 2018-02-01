//
//  KSCollectionView.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-22.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "KSCollectionView.h"

@implementation KSCollectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(id)initWithController:(UIViewController *) controller{
    if (self = [super init]) {
        self.controller = controller;
    }
    return self;
}


- (id)init
{
    self = [super init];
    if (self) {
//        self.backgroundColor = [UIColor colorWithHex:0xe2e3e3];
        self.backgroundView = nil;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0xe2e3e3];
        self.backgroundView = nil;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


@end

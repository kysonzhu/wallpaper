//
//  LatestCollectionView.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-22.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "LatestCollectionView.h"
#import "GalleryView.h"

static NSString *GridViewCellReuseIdentifier2 = @"GridViewCellReuseIdentifier2";

@implementation LatestCollectionView

-(id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        UINib *xibFile = [UINib nibWithNibName:@"GridViewCell2" bundle:nil];
        [self registerNib:xibFile forCellWithReuseIdentifier:GridViewCellReuseIdentifier2];
    }
    return self;
}


@end

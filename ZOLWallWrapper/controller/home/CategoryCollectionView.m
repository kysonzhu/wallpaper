//
//  CategoryCollectionView.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-22.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "CategoryCollectionView.h"
#import "GalleryView.h"
#import "CategoryCell.h"

@implementation CategoryCollectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        UINib *xibFile = [UINib nibWithNibName:@"CategoryCell" bundle:nil];
        [self registerNib:xibFile forCellWithReuseIdentifier:@"kCategoryCellIdentifier"];
    }
    return self;
}


@end

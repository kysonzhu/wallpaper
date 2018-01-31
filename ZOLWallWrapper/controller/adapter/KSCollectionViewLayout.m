//
//  KSCollectionViewLayout.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-24.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "KSCollectionViewLayout.h"

@implementation KSCollectionViewLayout


-(id)initWithDelegate:(id<KSCollectionViewLayoutDelegate>) delegate{
    if (self = [super init]) {
        self.mDelegate = delegate;
    }
    return self;
}



/**
 **/
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(kscollectionViewLayout:itemDidClicked:)]) {
        [self.mDelegate kscollectionViewLayout:self itemDidClicked:indexPath];
    }
}

@end

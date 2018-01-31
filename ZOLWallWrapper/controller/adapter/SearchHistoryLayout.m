//
//  SearchHistoryLayout.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 15-1-4.
//  Copyright (c) 2015年 zhujinhui. All rights reserved.
//

#import "SearchHistoryLayout.h"
#import "GridViewCell.h"
#import "Group.h"

static NSString *GridViewCellReuseIdentifier = @"GridViewCellReuseIdentifier";


@implementation SearchHistoryLayout


-(id)initWithDelegate:(id<SearchHistoryLayoutDelegate>) delegate{
    if (self = [super init]) {
        self.mDelegate = delegate;
    }
    return self;
}




-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    int mod = _groupList.count%3;
    
    int sectionCount = (int)_groupList.count/3;
    if (mod > 0 ) {
        sectionCount++;
        if (section == (sectionCount - 1) ) {
            return mod;
        }
    }
    
    return 3;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    int mod = _groupList.count%3;
    int sectionCount = (int)_groupList.count/3;
    if (mod > 0 ) {
        sectionCount++;
    }
    return sectionCount;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds )/3 - 2, 176);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(320, 2);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(320, 2);
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    Group *group = _groupList[section *3 +row ];
    GridViewCell   *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GridViewCellReuseIdentifier forIndexPath:indexPath];
    AutoLoadImageView *imageView = (AutoLoadImageView *)cell.coverImageView;
    [imageView loadImage:group.coverImgUrl];
    cell.themeNameLabel.text = group.gName;
    
    return cell;
}


/**
 **/
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(searchHistoryLayout:itemDidClicked:)]) {
        [self.mDelegate searchHistoryLayout:self itemDidClicked:indexPath];
    }
}


@end

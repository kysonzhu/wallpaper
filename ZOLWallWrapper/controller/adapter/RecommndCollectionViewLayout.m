//
//  RecommndCollectionViewLayout.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-22.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "RecommndCollectionViewLayout.h"
#import "GalleryView.h"
#import "GridViewCell.h"
#import "AutoLoadImageView.h"
#import "UserCenter.h"
#import <CoreText/CoreText.h>

static NSString *GridViewCellReuseIdentifier = @"GridViewCellReuseIdentifier";


@implementation RecommndCollectionViewLayout


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    if (0 ==  section) {
//        return 1;
//    }
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
//    NSInteger section = [indexPath section];
//    if (0 ==  section) {
//        return CGSizeMake(320, 130);
//    }
    return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds )/3 - 2, 176);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    if (0 == section) {
//        return 5;
//    }
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    if (0 == section) {
//        return CGSizeMake(320, 5);
//    }
    return CGSizeMake(320, 2);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
//    if (0 == section) {
//        return CGSizeMake(320, 5);
//    }
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
    
    //group number
    NSString *picNumString = [NSString stringWithFormat:@"(%i张)",[group.picNum intValue]];
    NSMutableAttributedString *attributePicNumString = [[NSMutableAttributedString alloc]initWithString:picNumString];
    NSDictionary *attriDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHex:0xc8c8c8],NSForegroundColorAttributeName,[UIFont systemFontOfSize:10],NSFontAttributeName, nil];
    NSRange range;
    range.length = [attributePicNumString length];
    range.location = 0;
    [attributePicNumString setAttributes:attriDictionary range:range];
    //group name
    NSMutableAttributedString *attributeGroupNameString = [[NSMutableAttributedString alloc]initWithString:group.gName];
    NSDictionary *attriDictionary2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil];
    NSRange range2;
    range2.length = [attributeGroupNameString length];
    range2.location = 0;
//    NSInteger stringLength = 0;
//    
//    
//    for (int i = 0; i < range2.length; ++ i) {
//        NSString *tempString = [attributeGroupNameString string];
//
//        int a = [tempString characterAtIndex:i ];
//        if (a > 0x4e00 && a < 0x9fff) {
//            ++ stringLength;
//        }
//        
//    }
//    if (stringLength > 12) {
//        NSString *tempString = [attributeGroupNameString string];
//        tempString = [tempString substringToIndex:10];
//        tempString = [NSString stringWithFormat:@"%@...",tempString];
//        attributeGroupNameString = [[NSMutableAttributedString alloc]initWithString:tempString];
//        range2.length = [attributeGroupNameString length];
//    }
    [attributeGroupNameString setAttributes:attriDictionary2 range:range2];
    NSMutableAttributedString *detailString = [[NSMutableAttributedString alloc]initWithAttributedString:attributePicNumString];
    [detailString insertAttributedString:attributeGroupNameString atIndex:0];
    
    cell.themeNameLabel.attributedText = detailString;
    BOOL isPraised = [[UserCenter shareInstance] isPraised:group.gId];
    //vote good
    NSString *voteGood = nil;
    if (isPraised) {
        voteGood = [NSString stringWithFormat:@"%i",[group.voteGood intValue] + 1];
    }else{
        voteGood = group.voteGood ;
    }
    cell.detailLabel.text = voteGood;
//    NSDictionary *dictionary = [[NSDictionary alloc]init];
//    cell.detailLabel.attributedText = [[NSAttributedString alloc]initWithString:@"风景(12张)" attributes:dictionary];

        return cell;
//    }

}

@end

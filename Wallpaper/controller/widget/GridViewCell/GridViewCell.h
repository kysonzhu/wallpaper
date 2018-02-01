//
//  GridViewCell.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-15.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AutoLoadImageView.h"


@interface GridViewCell : UICollectionViewCell


@property (nonatomic, weak) IBOutlet UIView *barView;

@property (nonatomic, weak) IBOutlet UIImageView *heartView;

@property (nonatomic, weak) IBOutlet UILabel *detailLabel;

@property (nonatomic, weak) IBOutlet UILabel *themeNameLabel;

@property (nonatomic, weak) IBOutlet AutoLoadImageView *coverImageView;

+(GridViewCell *)loadFromXib;


@end

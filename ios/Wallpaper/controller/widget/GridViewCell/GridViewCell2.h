//
//  GridViewCell2.h
//  WallWrapper ( https://github.com/kysonzhu/wallpaper.git )
//
//  Created by zhujinhui on 15-1-7.
//  Copyright (c) 2015年 zhujinhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoLoadImageView.h"

@interface GridViewCell2 : UICollectionViewCell


@property (nonatomic, weak) IBOutlet UIView *barView;

@property (nonatomic, weak) IBOutlet UILabel *detailLabel;

@property (nonatomic, weak) IBOutlet UILabel *themeNameLabel;

@property (nonatomic, weak) IBOutlet AutoLoadImageView *coverImageView;

@end

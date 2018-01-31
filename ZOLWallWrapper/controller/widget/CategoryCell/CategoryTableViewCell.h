//
//  CategoryTableViewCell.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-30.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoLoadImageView.h"

@interface CategoryTableViewCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel             *cateNameLabel;
@property (nonatomic,weak) IBOutlet UILabel             *cateDetailLabel;
@property (nonatomic,weak) IBOutlet AutoLoadImageView   *coverImageView;


@end

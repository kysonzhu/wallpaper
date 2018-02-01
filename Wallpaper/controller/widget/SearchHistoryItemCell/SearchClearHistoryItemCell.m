//
//  SearchClearHistoryItemCell.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 15/2/6.
//  Copyright (c) 2015年 zhujinhui. All rights reserved.
//

#import "SearchClearHistoryItemCell.h"

@implementation SearchClearHistoryItemCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [_clearCacheButton setTitleColor:[UIColor colorWithHex:0x333333 alpha:0.25] forState:UIControlStateNormal];
    [_clearCacheButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

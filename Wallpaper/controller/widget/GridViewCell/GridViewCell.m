//
//  GridViewCell.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-15.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "GridViewCell.h"
#import "UserCenter.h"

@interface GridViewCell (){
    
//    __weak
}

@end


@implementation GridViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


+(GridViewCell *)loadFromXib{
    GridViewCell *cell = [[NSBundle mainBundle]loadNibNamed:@"GridViewCell" owner:nil options:nil][0];
//    cell.coverImageView.image = nil;
    cell.coverImageView.backgroundColor = [[UserCenter shareInstance]getRandomColor];
    return cell;
}


-(void)awakeFromNib{
    [super awakeFromNib];
//    barView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.5];
    _themeNameLabel.textColor = [UIColor colorWithHex:0x666666];
}



@end

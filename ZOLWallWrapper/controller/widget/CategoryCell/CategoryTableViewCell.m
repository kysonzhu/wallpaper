//
//  CategoryTableViewCell.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-30.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "CategoryTableViewCell.h"

@interface CategoryTableViewCell (){
    __weak IBOutlet UILabel *subTitleLabel;
    __weak IBOutlet UIView  *separaterView;
}

@end


@implementation CategoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


-(void)awakeFromNib{
    [super awakeFromNib];
    [separaterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5f);
        make.left.mas_equalTo(105.f);
        make.bottom.equalTo(separaterView.superview.mas_bottom);
        make.right.equalTo(separaterView.superview.mas_right);
    }];
    _coverImageView.layer.cornerRadius = 5.f;
    subTitleLabel.textColor = [UIColor colorWithHex:0x999999];
    separaterView.backgroundColor = [UIColor colorWithHex:0xc8c8c8];
}



@end

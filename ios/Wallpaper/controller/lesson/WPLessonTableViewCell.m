//
//  WPLessonTableViewCell.m
//  Wallpaper
//
//  Created by kyson on 29/03/2018.
//  Copyright © 2018 zhujinhui. All rights reserved.
//

#import "WPLessonTableViewCell.h"
#import <Masonry/Masonry.h>

@interface WPLessonTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation WPLessonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
        make.top.equalTo(self.contentView.mas_top).offset(8.f);
        make.height.mas_equalTo(210.f);
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
        make.top.equalTo(self.coverImageView.mas_bottom).offset(5.f);
        make.height.mas_equalTo(20.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5.f);
    }];
}

+(WPLessonTableViewCell *)loadFromXib
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

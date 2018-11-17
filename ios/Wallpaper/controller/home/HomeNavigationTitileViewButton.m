//
//  HomeNavigationTitileViewButton.m
//  Wallpaper
//
//  Created by yao on 2018/2/3.
//  Copyright © 2018年 zhujinhui. All rights reserved.
//
#define TitleFont 18
#import "HomeNavigationTitileViewButton.h"
@interface HomeNavigationTitileViewButton()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *titleLine;
@property (nonatomic, strong) UITapGestureRecognizer *gesture;
@end
@implementation HomeNavigationTitileViewButton
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _titleLabel.font = [UIFont systemFontOfSize:TitleFont];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithHex:0x756a69];
    }
    return _titleLabel;
}

- (UIImageView *)titleLine{
    if (!_titleLine) {
        _titleLine = [[UIImageView alloc] initWithFrame:CGRectMake(self.titleLabel.center.x - TitleFont - 4 , self.titleLabel.bounds.size.height - 7, (TitleFont + 4) * 2, 4)];
        _titleLine.image = [UIImage imageNamed:@"nav_sel"];
    }
    return _titleLine;
}

- (UITapGestureRecognizer *)gesture{
    if (!_gesture) {
        _gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction)];
    }
    return _gesture;
}

- (void)layoutSubviews{
    [self addSubview:self.titleLabel];
    [self addSubview:self.titleLine];
    [self addGestureRecognizer:self.gesture];
    [self hidTitleLine];
   
}
- (void)hidTitleLine{
    if (self.isSelected) {
        self.titleLine.hidden = NO;
        self.titleLabel.textColor = [UIColor colorWithHex:0x389dc2];
    } else {
        self.titleLine.hidden = YES;
        self.titleLabel.textColor = [UIColor colorWithHex:0x756a69];
    }
}
- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    [self hidTitleLine];
}
- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
    
}

//点击相应的方法
- (void)gestureAction{
    self.isSelected = !self.isSelected;
    [self hidTitleLine];
    if (self.buttonAction) {
        self.buttonAction(self);
    }
    
}

@end

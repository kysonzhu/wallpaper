//
//  HomeNavigatiaonTitleView.m
//  Wallpaper
//
//  Created by yao on 2018/2/3.
//  Copyright © 2018年 zhujinhui. All rights reserved.
//

#import "HomeNavigatiaonTitleView.h"

@interface HomeNavigatiaonTitleView()
@property (nonatomic, strong) NSMutableArray * titleArray;
@property (nonatomic, strong) NSMutableArray * buttonArray;
@end

@implementation HomeNavigatiaonTitleView

- (void)layoutSubviews{
    for (int i = 0; i < self.buttonArray.count; i++) {
        HomeNavigationTitileViewButton *button = self.buttonArray[i];
        [button setTitle:self.titleArray[i]];
        button.buttonAction = ^(id button) {
            [self setButtonState:button];
            [self clickButton:button];
        };
        [self addSubview:button];
    }
}

- (void)clickButton:(HomeNavigationTitileViewButton *)button{
    if (self.clieckButtonAtIndex) {
        self.clieckButtonAtIndex(button, (int)button.tag - 100);
    }
}

- (void)setButtonState:(HomeNavigationTitileViewButton *)button{
    for (HomeNavigationTitileViewButton *btn in self.buttonArray) {
        if (button == btn) {
            btn.isSelected = YES;
        } else {
            btn.isSelected = NO;
        }
    }
    
}

- (void)setButtonHighlighedAtIndex:(int)index{
    for (int i = 0; i < self.buttonArray.count; i++) {
        HomeNavigationTitileViewButton *btn = self.buttonArray[i];
        if (i == index) {
            btn.isSelected = YES;
        } else {
            btn.isSelected = NO;
        }
    }
}

//添加button
- (void)addButton{
    int i = 0;
    float width = self.bounds.size.width / self.titleArray.count;
    float height = self.bounds.size.height;
    while (i < self.titleArray.count) {
        HomeNavigationTitileViewButton *button = [[HomeNavigationTitileViewButton alloc] initWithFrame:CGRectMake(width * i, 0, width, height)];
        [self.buttonArray addObject:button];
        button.tag = 100 + i;
        if (i == 0) {
            [button setIsSelected:YES];
        }
        i++;
    }
}

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
        [_titleArray addObject:@"宝贝"];
        [_titleArray addObject:@"壁纸"];
        [_titleArray addObject:@"分类"];
    }
    return _titleArray;
}

- (NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
        [self addButton];
    }
    return _buttonArray;
}

@end

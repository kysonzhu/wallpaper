//
//  HomeNavigationTitileViewButton.h
//  Wallpaper
//
//  Created by yao on 2018/2/3.
//  Copyright © 2018年 zhujinhui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HomeNavigationTitileViewButtonAction)(id button);

@interface HomeNavigationTitileViewButton : UIView

@property (nonatomic, assign) BOOL isSelected;//是否被点击选中

@property (nonatomic, copy) HomeNavigationTitileViewButtonAction buttonAction;

- (void)setTitle:(NSString *)title;

@end

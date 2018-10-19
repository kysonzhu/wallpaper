//
//  HomeNavigatiaonTitleView.h
//  Wallpaper
//
//  Created by yao on 2018/2/3.
//  Copyright © 2018年 zhujinhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeNavigationTitileViewButton.h"


typedef void(^HomeNavigatiaonTitleViewAction)(HomeNavigationTitileViewButton * button, int index);

@interface HomeNavigatiaonTitleView : UIView

@property (nonatomic, copy) HomeNavigatiaonTitleViewAction clieckButtonAtIndex;

- (void)setButtonHighlighedAtIndex:(int)index;

@end

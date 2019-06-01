//
//  PicToolBar.m
//  Wallpaper
//
//  Created by 陈浩宇 on 2019/5/31.
//  Copyright © 2019 zhujinhui. All rights reserved.
//

#import "PicToolBar.h"
//#import "ToolBarButton.h"
#import <Masonry.h>
#define ToolBarButtonHeight 25
#define ToolBarButtonWidth 31

@implementation PicToolBar

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        self.praiseButton = [[UIButton alloc] init];
        self.downloadButton = [[UIButton alloc] init];
        self.homeButton = [[UIButton alloc] init];
        self.lockButton = [[UIButton alloc] init];
        self.shareButton = [[UIButton alloc] init];
        
        self.lockButton.tag = TAG_BTN_LOCKSCREEN;
        self.homeButton.tag = TAG_BTN_LAUNCH;
        self.downloadButton.tag = TAG_BTN_DOWNLOAD;
        self.praiseButton.tag = TAG_BTN_PRAISE;
        self.shareButton.tag = TAG_BTN_SHARE;
        
        [self.praiseButton setBackgroundImage:[[UIImage imageNamed:@"tab_icon_collect"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal] ;
        [self.downloadButton setBackgroundImage:[[UIImage imageNamed:@"tab_icon_down"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [self.homeButton setBackgroundImage:[[UIImage imageNamed:@"tab_icon_desktop"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [self.lockButton setBackgroundImage:[[UIImage imageNamed:@"tab_icon_lock"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [self.shareButton setBackgroundImage:[[UIImage imageNamed:@"icon_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal] ;
        self = [super initWithArrangedSubviews:@[self.praiseButton, self.downloadButton, self.homeButton, self.lockButton, self.shareButton]];
        
        for (UIButton *button in self.arrangedSubviews) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@ToolBarButtonHeight);
                make.width.equalTo(@ToolBarButtonWidth);
            }];
            button.tintColor = UIColor.blackColor;
        }
        
        self.axis = UILayoutConstraintAxisHorizontal;
        self.distribution = UIStackViewDistributionEqualSpacing;
        self.alignment = UIStackViewAlignmentFill;
    }
    return self;
}

@end

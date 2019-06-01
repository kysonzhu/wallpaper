//
//  PicToolBar.h
//  Wallpaper
//
//  Created by 陈浩宇 on 2019/5/31.
//  Copyright © 2019 zhujinhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicToolBar : UIStackView

#define TAG_BTN_LOCKSCREEN  2110
#define TAG_BTN_LAUNCH        2111
#define TAG_BTN_DOWNLOAD    2112
#define TAG_BTN_PRAISE      2114
#define TAG_BTN_SHARE       2115

#define TAG_IMGV_HOME        211
#define TAG_IMGV_LOCKSCREEN  212

@property(nonatomic,strong) UIButton *praiseButton;
@property(nonatomic,strong) UIButton *downloadButton;
@property(nonatomic,strong) UIButton *homeButton;
@property(nonatomic,strong) UIButton *lockButton;
@property(nonatomic,strong) UIButton *shareButton;

@end

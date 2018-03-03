//
//  YXViewPagerTopItemView.m
//  Pods
//
//  Created by yixiang on 17/3/29.
//
//

#import "YXViewPagerTopItemView.h"
#import "YXViewPagerUtility.h"

static CGFloat const kIconSize = 25.f;
static CGFloat const kTitleSize = 11;
static NSString *const kNormalTitleColor = @"#666666";
static NSString *const kSelectTitleColor = @"#3d3d3d";
static NSString *const kNormalIconName = @"ic_element_tabbar_home_normal";
static NSString *const kSelectIconName = @"ic_element_tabbar_home_pressed";

@interface YXViewPagerTopItemView()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) YXViewPagerItemViewModel *viewModel;
@property (nonatomic, copy)   YXViewPagerTopItemViewSelectCallBack selectCallBack;

@end

@implementation YXViewPagerTopItemView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _iconView = [[UIImageView alloc] init];
        [self addSubview:_iconView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kTitleSize];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClicked)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:gesture];
        
    }
    return self;
}

- (void)renderUIWithViewModel:(YXViewPagerItemViewModel *)viewModel{
    _viewModel = viewModel;
    YXViewPagerItemViewType itemType = viewModel.itemType;
    switch (itemType) {
        case YXViewPagerItemViewTypeForText:
            [self renderTextType:viewModel];
            break;
        case YXViewPagerItemViewTypeForImage:
            [self renderImageType:viewModel];
            break;
        case YXViewPagerItemViewTypeForTextAndImage:
            [self renderTextAndImageType:viewModel];
            break;
        default:
            break;
    }
}

- (void)settingTabSelect:(BOOL)select{
    YXViewPagerItemViewType itemType = _viewModel.itemType;
    switch (itemType) {
        case YXViewPagerItemViewTypeForText:
            if (select) {
                [self settingTitleColor:_viewModel.selectTitleColor];
            }else{
                [self settingTitleColor:_viewModel.normalTitleColor];
            }
            break;
        case YXViewPagerItemViewTypeForImage:
            if (select) {
                [self settingIconName:_viewModel.selectIconName];
            }else{
                [self settingIconName:_viewModel.normalIconName];
            }
            break;
        case YXViewPagerItemViewTypeForTextAndImage:
            if (select) {
                [self settingTitleColor:_viewModel.selectTitleColor];
                [self settingIconName:_viewModel.selectIconName];
            }else{
                [self settingTitleColor:_viewModel.normalTitleColor];
                [self settingIconName:_viewModel.normalIconName];
            }
            break;
        default:
            break;
    }
}

- (void)renderTextType:(YXViewPagerItemViewModel *)viewModel{
    _titleLabel.frame = self.bounds;
    _titleLabel.text = viewModel.title;
    [self settingTitleColor:viewModel.normalTitleColor];
}

- (void)renderImageType:(YXViewPagerItemViewModel *)viewModel{
    rm(_iconView, self.width/2-kIconSize/2, self.height/2-kIconSize/2, kIconSize, kIconSize);
    [self settingIconName:viewModel.normalIconName];
}


- (void)renderTextAndImageType:(YXViewPagerItemViewModel *)viewModel{
    rm(_iconView, self.width/2-kIconSize/2, 9.5, kIconSize, kIconSize);
    [self settingIconName:viewModel.normalIconName];
    
    rm(_titleLabel, 0, self.height-9.5-kTitleSize, self.width, kTitleSize);
    _titleLabel.text = viewModel.title;
    [self settingTitleColor:viewModel.normalTitleColor];
}


/**
 设置图标
 
 @param iconName
 */
- (void)settingIconName:(NSString *)iconName{
    if (STRING_IS_BLANK(iconName)) {
        _iconView.image = [UIImage imageNamed:kNormalIconName];
    }else{
        _iconView.image = [UIImage imageNamed:iconName];
    }
}


/**
 设置文本颜色
 
 @param titleColor
 */
- (void)settingTitleColor:(NSString *)titleColor{
    if (STRING_IS_BLANK(titleColor)) {
        _titleLabel.textColor = [UIColor colorWithHexString:kNormalTitleColor];
    }else{
        _titleLabel.textColor = [UIColor colorWithHexString:titleColor];
    }
}

- (void)addSelectedCallBack:(YXViewPagerTopItemViewSelectCallBack)callback{
    _selectCallBack = callback;
}

- (void)itemClicked{
    if (_selectCallBack) {
        _selectCallBack(self.tag);
    }
}

@end

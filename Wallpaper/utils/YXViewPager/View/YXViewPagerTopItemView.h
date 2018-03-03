//
//  YXViewPagerTopItemView.h
//  Pods
//
//  Created by yixiang on 17/3/29.
//
//

#import <UIKit/UIKit.h>
#import "YXViewPagerItemViewModel.h"

typedef void (^YXViewPagerTopItemViewSelectCallBack)(NSInteger tag);

@interface YXViewPagerTopItemView : UIView

- (void)renderUIWithViewModel : (YXViewPagerItemViewModel *)viewModel;

- (void)settingTabSelect:(BOOL)select;

- (void)addSelectedCallBack:(YXViewPagerTopItemViewSelectCallBack)callback;

@end

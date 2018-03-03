//
//  YXViewPagerItemViewModel.h
//  Pods
//
//  Created by yixiang on 17/3/29.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YXViewPagerItemViewType) {
    YXViewPagerItemViewTypeForText = 0,
    YXViewPagerItemViewTypeForImage,
    YXViewPagerItemViewTypeForTextAndImage
};

@interface YXViewPagerItemViewModel : NSObject

@property (nonatomic, assign) YXViewPagerItemViewType itemType;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *normalTitleColor;//default #666666
@property (nonatomic, strong) NSString *selectTitleColor;//default #3d3d3d

@property (nonatomic, strong) NSString *normalIconName;//defult ic_element_tabbar_home_normal
@property (nonatomic, strong) NSString *selectIconName;//defult ic_element_tabbar_home_pressed


@property (nonatomic, assign) BOOL hasShow;//该页面是否已经展示过
@property (nonatomic, strong) NSString *vcName;//vc的名字
@property (nonatomic, strong) UIViewController *vcInstance;//vc的实例

@end

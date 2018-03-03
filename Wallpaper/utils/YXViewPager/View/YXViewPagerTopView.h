//
//  YXViewPagerTopView.h
//  Pods
//
//  Created by yixiang on 17/3/29.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YXViewPagerTopViewType) {
    YXViewPagerTopViewTypeForNoScroll = 0,//default 总宽度为屏幕宽度，不可滚动，每个item的宽度，根据item的个数确定。适合item数比较少的情况
    YXViewPagerTopViewTypeForCanScroll//每个item的宽度确定，超过屏幕可以滑动。适合item数比较多的情况。
};

typedef void (^YXViewPagerTopViewTypeItemClickBlock)(NSInteger tag);

@interface YXViewPagerTopView : UIView


@property (nonatomic, assign) YXViewPagerTopViewType type;//default YXCommonUITabsTopViewTypeForNoScroll
@property (nonatomic, assign) CGFloat itemWidth;//如果type==YXViewPagerTopViewTypeForCanScroll，需要指定宽度
@property (nonatomic, strong) NSString *maskColor;//遮罩层的颜色 default@"#FFEEAE"

@property (nonatomic, strong) UIScrollView *tabScroller;
@property (nonatomic, strong) UIView *maskView;

- (void)renderUIWithArray : (NSArray *)dataArray;

- (void)tabItemSelected:(NSInteger)index;


- (void)addItemClickBlock : (YXViewPagerTopViewTypeItemClickBlock) block;


@end

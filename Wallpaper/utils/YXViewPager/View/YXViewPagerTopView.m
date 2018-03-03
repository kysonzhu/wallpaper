//
//  YXViewPagerTopView.m
//  Pods
//
//  Created by yixiang on 17/3/29.
//
//

#import "YXViewPagerTopView.h"
#import "YXViewPagerUtility.h"
#import "YXViewpagerItemViewModel.h"
#import "YXViewPagerTopItemView.h"

@interface YXViewPagerTopView()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *tabViews;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy) YXViewPagerTopViewTypeItemClickBlock itemClickBlock;

@end

@implementation YXViewPagerTopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initMaskView];
        [self initTabScroller];
    }
    return self;
}

- (void)initMaskView{
    _maskView = [[UIView alloc] initWithFrame:CGRectZero];
    _maskView.backgroundColor = [UIColor colorWithHexString:@"#FFEEAE"];
    [self addSubview:_maskView];
}

- (void)initTabScroller{
    _tabScroller = [[UIScrollView alloc] initWithFrame:self.bounds];
    _tabScroller.showsHorizontalScrollIndicator = NO;
    _tabScroller.backgroundColor = [UIColor clearColor];
    _tabScroller.bounces = NO;
    _tabScroller.delegate = self;
    [self addSubview:_tabScroller];
}

- (void)setMaskColor:(NSString *)maskColor{
    _maskView.backgroundColor = [UIColor colorWithHexString:maskColor];
}

- (void)renderUIWithArray:(NSArray *)dataArray{
    if (ARRAY_IS_EMPTY(dataArray)) return;
    
    CGFloat offsetX = 0;
    [self handleItemWidthWithItemCount:dataArray.count];
    _maskView.frame = CGRectMake(0, 0, _itemWidth, self.height);
    _tabViews = [[NSMutableArray alloc] init];
    for (int i=0; i<dataArray.count; i++) {
        YXViewPagerItemViewModel *model = dataArray[i];
        YXViewPagerTopItemView *itemView = [[YXViewPagerTopItemView alloc] initWithFrame:CGRectMake(offsetX, 0, _itemWidth, self.height)];
        [itemView renderUIWithViewModel:model];
        itemView.tag = i;
        [_tabScroller addSubview:itemView];
        offsetX += _itemWidth;
        
        [_tabViews addObject:itemView];
        
        __weak typeof(self) weakSelf = self;
        [itemView addSelectedCallBack:^(NSInteger tag) {
            if (weakSelf.itemClickBlock) {
                weakSelf.itemClickBlock(tag);
            }
        }];
    }
    _tabScroller.contentSize = CGSizeMake(dataArray.count*_itemWidth, self.height);
}

- (void)handleItemWidthWithItemCount:(NSInteger)count{
    if (_type == YXViewPagerTopViewTypeForNoScroll) {
        _itemWidth = self.width/count;
    }else if(_type == YXViewPagerTopViewTypeForCanScroll){
        if (_itemWidth<1) {//如果在canScroll的模式下面,没有设置itemWidth，默认和noScroll一样处理
            _itemWidth = self.width/count;
        }
    }
}

- (void)tabItemSelected:(NSInteger)index{
    _currentIndex = index;
    for (int i=0; i<_tabViews.count; i++) {
        YXViewPagerTopItemView *tabView = _tabViews[i];
        if (i == index) {
            [tabView settingTabSelect:YES];
        }else{
            [tabView settingTabSelect:NO];
        }
    }
}

- (void)addItemClickBlock : (YXViewPagerTopViewTypeItemClickBlock) block{
    _itemClickBlock = block;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat itemWidth = _itemWidth;
    CGFloat offsetX = scrollView.contentOffset.x;
    _maskView.frame = CGRectMake(_currentIndex*itemWidth-offsetX, 0, _maskView.width, _maskView.height);
}


@end

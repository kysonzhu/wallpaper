//
//  YXViewPagerBaseViewController.m
//  Pods
//
//  Created by yixiang on 17/3/29.
//
//

#import "YXViewPagerBaseViewController.h"
#import "YXViewPagerEventDelegate.h"
#import "YXViewPagerTopView.h"
#import "YXViewPagerItemViewModel.h"
#import "YXViewPagerUtility.h"
#import "YXViewPagerBaseSubViewController.h"

@interface YXViewPagerBaseViewController ()<UIScrollViewDelegate,YXViewPagerEventDelegate>

@property (nonatomic, strong) YXViewPagerTopView *topView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *topViewBgColor;
@property (nonatomic, strong) NSString *maskColor;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, strong) UIScrollView *contentScroller;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation YXViewPagerBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (NSDictionary *)getPageConfigInfo{
    return nil;
}

- (void)renderUI{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F3F4"];
    [self initData];
    [self initTopView];
    [self initContentScroller];
    [self tabItemSelected:0];
}

- (void)initData{
    NSDictionary *configInfo = [self getPageConfigInfo];
    _topViewBgColor = configInfo[@"topViewBgColor"];
    _maskColor = configInfo[@"maskColor"];
    _type = [configInfo[@"type"] integerValue];
    if (_type == YXViewPagerTopViewTypeForCanScroll) {
        _itemWidth = [configInfo[@"itemWidth"] floatValue];
    }
    
    NSArray *dataArray = configInfo[@"dataArray"];
    _dataArray = [[NSMutableArray alloc] init];
    for (int i=0; i<dataArray.count; i++) {
        NSDictionary *itemInfo = dataArray[i];
        YXViewPagerItemViewModel *viewModel = [[YXViewPagerItemViewModel alloc] init];
        viewModel.itemType = [itemInfo[@"itemType"] integerValue];
        viewModel.title = itemInfo[@"title"];
        viewModel.normalTitleColor = itemInfo[@"normalTitleColor"];
        viewModel.selectTitleColor = itemInfo[@"selectTitleColor"];
        viewModel.normalIconName = itemInfo[@"normalIconName"];
        viewModel.selectIconName = itemInfo[@"selectIconName"];
        viewModel.vcName = itemInfo[@"vcName"];
        
        [_dataArray addObject:viewModel];
    }
}

- (void)initTopView{
    _topView = [[YXViewPagerTopView alloc] initWithFrame:CGRectMake(0, [self navBarHeight], self.view.width, 60)];
    if (!STRING_IS_BLANK(_topViewBgColor)) {
        _topView.backgroundColor = [UIColor colorWithHexString:_topViewBgColor];
    }
    if (!STRING_IS_BLANK(_maskColor)) {
        _topView.maskColor = _maskColor;
    }
    if (_type == YXViewPagerTopViewTypeForCanScroll) {
        _topView.type = _type;
        _topView.itemWidth = _itemWidth;
    }
    [_topView renderUIWithArray:_dataArray];
    __weak typeof(self) weakSelf = self;
    [_topView addItemClickBlock:^(NSInteger tag) {
        [weakSelf tabItemSelected:tag];
    }];
    [self.view addSubview:_topView];
}

- (void)initContentScroller{
    _contentScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _topView.bottom, self.view.width, self.view.height-_topView.bottom)];
    _contentScroller.pagingEnabled = YES;
    _contentScroller.delegate = self;
    _contentScroller.bounces = NO;
    _contentScroller.showsHorizontalScrollIndicator = NO;
    _contentScroller.contentSize = CGSizeMake(_contentScroller.width*_dataArray.count, _contentScroller.height);
    [self.view addSubview:_contentScroller];
}


- (void)tabItemSelected:(NSInteger)index needAnimation:(BOOL)needAnimation{
    _currentIndex = index;
    [_topView tabItemSelected:index];
    [_contentScroller setContentOffset:CGPointMake(index*_contentScroller.width, 0) animated:needAnimation];
    [self loadSubViewController];
}


- (void)tabItemSelected:(NSInteger)index{
    [self tabItemSelected:index needAnimation:YES];
}

- (void)loadSubViewController{
    NSLog(@"====yx======%zi",_currentIndex);
    
    YXViewPagerItemViewModel *viewModel = _dataArray[_currentIndex];
    
    BOOL hasShow = viewModel.hasShow;
    if (!hasShow) {
        viewModel.hasShow = YES;
        YXViewPagerBaseSubViewController *vc = [self getSubViewControllerByViewModel:viewModel];
        if (vc) {
            UIView *contentView = vc.view;
            contentView.frame = CGRectMake(_currentIndex*_contentScroller.width, 0, _contentScroller.width, _contentScroller.height);
            [_contentScroller addSubview:contentView];
            viewModel.vcInstance = vc;
            vc.rootToSubInfo = _rootToSubInfo;
            vc.rootVc = self;
            vc.delegate = self;
        }
    }else{
        YXViewPagerBaseSubViewController *vc = viewModel.vcInstance;
        vc.rootToSubInfo = _rootToSubInfo;
    }
}

- (YXViewPagerBaseSubViewController *)getSubViewControllerByViewModel: (YXViewPagerItemViewModel *)viewModel{
    
    NSString *vcName = viewModel.vcName;
    Class vcClass = NSClassFromString(vcName);
    
    if ([vcClass isSubclassOfClass:[YXViewPagerBaseSubViewController class]]) {
        YXViewPagerBaseSubViewController *vc = [[vcClass alloc] init];
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
        return vc;
    }
    
    return nil;
}

- (void)handleEventWithEventName:(NSString *)eventName context:(NSDictionary *)context{
    NSLog(@"eventName == %@",eventName);
    NSLog(@"content == %@",context);
    if (!STRING_IS_BLANK(eventName)) {
        if ([eventName isEqualToString:@"jumpOtherType"]) {
            NSInteger index = [context[@"index"] integerValue];
            [self tabItemSelected:index];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //1、滑动到当前page的处理
    CGFloat pageRate = scrollView.contentOffset.x/scrollView.width;
    if (((int)(pageRate*1000))%1000<1) {
        int page = (int)pageRate;//当前滑动到的page
        if (_currentIndex != page) {
            _currentIndex = page;
            [self tabItemSelected:_currentIndex];
        }
    }
    
    //2、YXCommonUITabsTopViewTypeForNoScroll模式下面 对于maskView的处理
    CGFloat rate = scrollView.contentOffset.x/scrollView.contentSize.width;
    CGFloat tabWidth = _topView.tabScroller.contentSize.width;
    CGFloat itemWidth = _topView.maskView.width;
    UIView *maskView = _topView.maskView;
    if (_type == YXViewPagerTopViewTypeForNoScroll) {
        maskView.frame = CGRectMake(rate*self.view.width, maskView.top, maskView.width, maskView.height);
    }else if(_type == YXViewPagerTopViewTypeForCanScroll){
        CGFloat centerX = tabWidth*rate+itemWidth/2;
        if (centerX>self.view.width/2 && centerX<tabWidth-self.view.width/2) {
            _topView.tabScroller.contentOffset = CGPointMake(centerX-self.view.width/2, 0);
            maskView.frame = CGRectMake(self.view.width/2-itemWidth/2, maskView.top, maskView.width, maskView.height);
        }
        
        if (centerX <= self.view.width/2) {
            _topView.tabScroller.contentOffset = CGPointMake(0, 0);
            maskView.frame = CGRectMake(tabWidth*rate, maskView.top, maskView.width, maskView.height);
        }
        
        if (centerX >= tabWidth-self.view.width/2) {
            _topView.tabScroller.contentOffset = CGPointMake(tabWidth-self.view.width, 0);
            maskView.frame = CGRectMake(self.view.width/2+tabWidth*rate-(tabWidth-self.view.width/2), maskView.top, maskView.width, maskView.height);
        }
    }
}

-(CGFloat)navBarHeight{
    CGFloat height = 0.f;
    height = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    return height;
}


@end

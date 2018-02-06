//
//  HomeViewController.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-9.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "HomeViewController.h"
#import "GridViewCell.h"
#import "RecommndCollectionView.h"
#import "LatestCollectionView.h"
#import "CategoryTableView.h"
#import "RecommndCollectionViewLayout.h"
#import "LatestCollectionViewLayout.h"
#import "SearchViewController.h"

#import "WrapperDetailViewController.h"
#import "SubCategoryViewController.h"

#import "GalleryView.h"
#import "ViewPager.h"
#import "ViewPagerAdapter.h"

#import "AppDelegate.h"
#import "DDMenuController.h"

#import "MGTaskPool.h"
#import "WrapperServiceMediator.h"
#import "Group.h"
#import "Classification.h"
#import "UIScrollView+MJRefresh.h"

#import "EnvironmentConfigure.h"
#import "HomeNavigatiaonTitleView.h"
@import GoogleMobileAds;


#define TAG_BTN_RECOMMEND   8907
#define TAG_BTN_LATEST      8908
#define TAG_BTN_CATEGORY    8909
#define TAG_BTN_NAV_LEFT    8910
#define TAG_BTN_NAV_RIGHT   8911
#define TAG_BTN_NAV_TITLE   8912

@interface HomeViewController ()<ViewPagerDelegate,KSCollectionViewLayoutDelegate,CategoryTableViewDelegate,GADBannerViewDelegate>{
    __weak IBOutlet UIButton *recommendButton;
    __weak IBOutlet UIButton *latestButton;
    __weak IBOutlet UIButton *categoryButton;
    __weak IBOutlet UIView *seperateView;
    ViewPager *mViewPager;
    UIButton *leftNavigationBarButton;
    UIButton *rightNavigationBarButton;
}

@property (nonatomic, assign) int startRecommended,startLatest;
@property (nonatomic, assign) BOOL isFirstTimeFetchDataLatest;
@property (nonatomic, assign) BOOL isFirstTimeFetchDataCategory;
@property (nonatomic, assign) BOOL isFirstTimeFetchDataRecommended;
@property (nonatomic, strong) HomeNavigatiaonTitleView *titleView;
@property (weak, nonatomic) IBOutlet UIView *titleBarView;

@property (nonatomic, strong) LatestCollectionView        *mLastestCollectionView;;
@property (nonatomic, strong) CategoryTableView           *mCategoryTableView;;
@property (nonatomic, strong) RecommndCollectionView      *mRecommndCollectionView;

@property(nonatomic, strong) GADBannerView *bannerView;

@end

@implementation HomeViewController

@synthesize startRecommended,startLatest;

@synthesize isFirstTimeFetchDataLatest,isFirstTimeFetchDataCategory,isFirstTimeFetchDataRecommended;
- (HomeNavigatiaonTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[HomeNavigatiaonTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 200 , 44)];
    }
    return _titleView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isFirstTimeFetchDataCategory = YES;
    isFirstTimeFetchDataLatest = YES;
    isFirstTimeFetchDataRecommended = YES;
    startRecommended = 0;
    startLatest = 0;
    
    /**
     *  navigation bar left bar button
     */
    UIBarButtonItem *btnItem1 = [[UIBarButtonItem alloc]init];
    leftNavigationBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image1 = [UIImage imageNamed:@"nav_icon_home"];
    [leftNavigationBarButton setBackgroundImage:image1 forState:UIControlStateNormal];
    [leftNavigationBarButton setFrame:CGRectMake(0, 0, 23, 20)];
    [leftNavigationBarButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftNavigationBarButton.tag = TAG_BTN_NAV_LEFT;
    [btnItem1 setCustomView:leftNavigationBarButton];
    self.navigationItem.leftBarButtonItem = btnItem1;
    /**
     * navigation bar right button
     */
    UIBarButtonItem *btnItem2 = [[UIBarButtonItem alloc]init];
    rightNavigationBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image2 = [UIImage imageNamed:@"nav_icon_sea"];
    [rightNavigationBarButton setBackgroundImage:image2 forState:UIControlStateNormal];
    [rightNavigationBarButton setFrame:CGRectMake(0, 0, 20, 20)];
    [rightNavigationBarButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    rightNavigationBarButton.tag = TAG_BTN_NAV_RIGHT;
    [btnItem2 setCustomView:rightNavigationBarButton];
    self.navigationItem.rightBarButtonItem = btnItem2;
    
    //    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    button.frame= CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 44);
    //    [button setTitle:@"壁纸宝贝" forState:UIControlStateNormal];
    //    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    //    button.tag = TAG_BTN_NAV_TITLE;
    //    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    self.navigationItem.titleView = button;
    __weak typeof(self) weakself = self;
    self.titleView.clieckButtonAtIndex = ^(HomeNavigationTitileViewButton *button, int index) {
        UIButton *btn = [UIButton buttonWithType:0];
        if (index == 0) {
            btn.tag = TAG_BTN_LATEST;
        } else if (index == 1) {
            btn.tag = TAG_BTN_RECOMMEND;
        }
        else if (index == 2) {
            btn.tag = TAG_BTN_CATEGORY;
        }
        [weakself buttonClicked:btn];
    };
    self.navigationItem.titleView = self.titleView;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    /*
     * Button init and event binding
     */
    recommendButton.tag = TAG_BTN_RECOMMEND;
    latestButton.tag    = TAG_BTN_LATEST;
    categoryButton.tag  = TAG_BTN_CATEGORY;
    
    [recommendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(recommendButton.superview);
        make.top.mas_equalTo(0.f);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    [latestButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(recommendButton.mas_left).offset(-60);
        make.top.mas_equalTo(0.f);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    [categoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(recommendButton.mas_right).offset(60);
        make.top.mas_equalTo(0.f);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    [recommendButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [latestButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [categoryButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    /*
     * ViewPager init and set frame
     */
    ViewPagerAdapter *adapter = [[ViewPagerAdapter alloc]init];
    CGRect frame = [UIScreen mainScreen].bounds;
    if (@available(iOS 11.0, *)) {
        if (KIsiPhoneX) {
            CGRect frame2 = self.titleBarView.frame;
            frame2.origin.y = 88;
            self.titleBarView.frame = frame2;
            
            frame.size.height -= (88);
            frame.origin.y = (88);
        }else
        {
            frame.size.height -= (64);
            frame.origin.y = (64);
        }
    } else {
        frame.size.height -= (64);
        frame.origin.y = (64);
    }
    mViewPager = [[ViewPager alloc]initWithFrame:frame];
    mViewPager.mDelegate = self;
    [self.view addSubview:mViewPager];
    
    /**
     *  Do any additional setup after loading the view from its nib.
     */
    self.title = @"壁纸宝贝";
    seperateView.backgroundColor = [UIColor colorWithHex:0xc8c8c8];
    //init recommend
    
    NSArray *array = [NSArray arrayWithObjects:self.mLastestCollectionView,self.mRecommndCollectionView,self.mCategoryTableView, nil];
    adapter.views = array;
    [mViewPager setAdapter:adapter];
    
    // In this case, we instantiate the banner with desired ad size.
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.bannerView];
    self.bannerView.adUnitID = @"ca-app-pub-7896672979027584/7587295301";
    //    self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
    self.bannerView.delegate = self;
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"adViewDidReceiveAd");
    adView.alpha = 0;
    [UIView animateWithDuration:1.0 animations:^{
        adView.alpha = 1;
        [self handleBanner];
    }];
    
}

/// Tells the delegate an ad request failed.
- (void)adView:(GADBannerView *)adView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
    [self handleBanner];
}

- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView
{
    self.bannerView.hidden = YES;
    [self handleBanner];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    NSInteger page = mViewPager.currentPage;
    if (0 == page) {
        [self buttonClicked:latestButton];
    }else if (1== page){
        [self buttonClicked:recommendButton];
    }else if (2 == page){
        [self buttonClicked:categoryButton];
    }
    [self handleBanner];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.barTintColor =  [UIColor colorWithHex:0x1fb1e8];
}
-(void)handleBanner{
    if (self.bannerView.hidden == YES || self.bannerView.alpha == 0) {
        [mViewPager mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(mViewPager.frame.origin.y);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }else{
        [mViewPager mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(mViewPager.frame.origin.y);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-50);
        }];
    }
}

#pragma mark - ScrollView Delegate

- (void)viewPagerDidEndDecelerating:(ViewPager *)viewPager{
    NSInteger page = viewPager.currentPage;
    if (0 == page) {
        [self buttonClicked:latestButton];
    }else if (1== page){
        [self buttonClicked:recommendButton];
    }else if (2 == page){
        [self buttonClicked:categoryButton];
    }
    
}

-(void)viewPagerDidScroll:(ViewPager *)viewPager{
    CGFloat contentOffsetX = viewPager.scrollView.contentOffset.x;
    //if draged to the firstpage , we can show the menu
    if (contentOffsetX < -5) {
        AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        DDMenuController *rootViewController =  (DDMenuController *)delegate.window.rootViewController;
        [rootViewController showLeftController:YES];
    }
}

-(void)viewPagerItemDidClicked:(int)index imageName:(NSString *)imageName imageUrl:(NSString *)imageUrl{
    switch (index) {
        case 0:{
            [self buttonClicked:latestButton];
        }
            break;
        case 1:{
            [self buttonClicked:recommendButton];
        }
            break;
        case 2:{
            [self buttonClicked:categoryButton];
        }
            break;
            
        default:
            break;
    }
}

/*
 * Set Button highlight manually
 */
-(void)setButtonHighlighed:(UIButton *) button{
    [recommendButton setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [latestButton setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [categoryButton setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    switch (button.tag) {
        case TAG_BTN_RECOMMEND:{
            [recommendButton setTitleColor:[UIColor colorWithHex:0x1fb1e8] forState:UIControlStateNormal];
        }
            break;
        case TAG_BTN_LATEST:{
            [latestButton setTitleColor:[UIColor colorWithHex:0x1fb1e8] forState:UIControlStateNormal];
        }
            break;
        case TAG_BTN_CATEGORY:{
            [categoryButton setTitleColor:[UIColor colorWithHex:0x1fb1e8] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

/*
 *   Button event
 */
-(void)buttonClicked:(UIButton *) button{
    //dissmiss out of network view
    switch (button.tag) {
        case TAG_BTN_RECOMMEND:{
            mViewPager.currentPage = 1;
            [self setButtonHighlighed:button];
            [self.titleView setButtonHighlighedAtIndex:1];
            //request
            if (isFirstTimeFetchDataRecommended) {
                WrapperServiceMediator *serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_RECOMMENDEDLIST params:@{@"start":@"0"}];
                [self doNetworkService:serviceMediator];
                [KVNProgress show];
            }
        }
            break;
        case TAG_BTN_LATEST:{
            mViewPager.currentPage = 0;
            [self setButtonHighlighed:button];
            [self.titleView setButtonHighlighedAtIndex:0];
            //request
            if (isFirstTimeFetchDataLatest) {
                WrapperServiceMediator *serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_LATESTLIST params:@{@"start":@"0"}];
                self.startLatest = 0;
                [self doNetworkService:serviceMediator];
                [KVNProgress show];
            }
        }
            break;
        case TAG_BTN_CATEGORY:{
            mViewPager.currentPage = 2;
            [self setButtonHighlighed:button];
            [self.titleView setButtonHighlighedAtIndex:2];
            //request
            if (isFirstTimeFetchDataCategory ) {
                WrapperServiceMediator *serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_CATEGORYLIST params:@{@"start":@"0"}];
                [self doNetworkService:serviceMediator];
                [KVNProgress show];
            }
        }
            break;
        case TAG_BTN_NAV_TITLE:{
            if (mViewPager.currentPage == 0) {
                [self.mLastestCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
            }else if (mViewPager.currentPage == 1){
                [self.mRecommndCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
        }
            break;
        case TAG_BTN_NAV_LEFT:{
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            DDMenuController *rootViewController =  (DDMenuController *)delegate.window.rootViewController;
            [rootViewController showLeftController:YES];
        }
            break;
        case TAG_BTN_NAV_RIGHT:{
            SearchViewController *searchViewController = [[SearchViewController alloc]initWithNibName:@"SearchViewController_iphone" bundle:nil];
            [self.navigationController pushViewController:searchViewController animated:YES];
        }
            break;
            
        default:
            break;
    }
}

/**
 * layout
 */
-(void)kscollectionViewLayout:(KSCollectionViewLayout *)layout itemDidClicked:(NSIndexPath *)indexPath{
    //push to detail
    if ([layout isKindOfClass:[RecommndCollectionViewLayout class]]) {
        NSInteger section = [indexPath section];
        NSInteger row = [indexPath row];
        RecommndCollectionViewLayout *layout1 = (RecommndCollectionViewLayout *)self.mRecommndCollectionView.collectionViewLayout;
        NSArray *groupList = layout1.groupList;
        Group *group = groupList[section *3 +row ];
        WrapperDetailViewController *detailViewController = [[WrapperDetailViewController alloc]initWithNibName:@"WrapperDetailViewController_iphone" bundle:nil];
        detailViewController.fromcontroller = FromControllerRecommended;
        detailViewController.group = group;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }else if ([layout isKindOfClass:[LatestCollectionViewLayout class]]){
        NSInteger section = [indexPath section];
        NSInteger row = [indexPath row];
        LatestCollectionViewLayout *layout1 = (LatestCollectionViewLayout *)self.mLastestCollectionView.collectionViewLayout;
        NSArray *groupList = layout1.groupList;
        Group *group = groupList[section *3 +row ];
        
        WrapperDetailViewController *detailViewController = [[WrapperDetailViewController alloc]initWithNibName:@"WrapperDetailViewController_iphone" bundle:nil];
        detailViewController.fromcontroller = FromControllerLatest;
        detailViewController.group = group;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}


-(void)refreshData:(NSString *)serviceName response:(MGNetwokResponse *)response{
    [KVNProgress dismiss];
    if (response.errorCode == 0) {
        if ([serviceName isEqualToString:SERVICENAME_RECOMMENDEDLIST]) {
            NSDictionary *resultDict = response.rawResponseDictionary;
            NSArray *Aryresponse1 = resultDict[@"result"][@"groupList"];
            Group *group = [[Group alloc] init];
            Aryresponse1 = [group loadArrayPropertyWithDataSource:Aryresponse1 requireModel:@"Group"];
            NSMutableArray *Aryresponse = [[NSMutableArray alloc] init];
            for (Group *item in Aryresponse1)
            {
                NSURL *coverUrl = [NSURL URLWithString:item.coverImgUrl];
                if ([coverUrl.scheme isEqualToString:@"http"] || [coverUrl.scheme isEqualToString:@"https"]) {
                    [Aryresponse addObject:item];
                }
            }
            RecommndCollectionViewLayout *layout1 = (RecommndCollectionViewLayout *)self.mRecommndCollectionView.collectionViewLayout;
            NSMutableArray *temAry = nil;
            if (startRecommended != 0) {
                temAry = [[NSMutableArray alloc]initWithArray:layout1.groupList];
            }else{
                temAry = [[NSMutableArray alloc]init];
            }
            [temAry addObjectsFromArray:Aryresponse];
            layout1.groupList = temAry;
            [self.mRecommndCollectionView reloadData];
            [self.mRecommndCollectionView .mj_footer endRefreshing];
            [self.mRecommndCollectionView .mj_header endRefreshing];
            isFirstTimeFetchDataRecommended = NO;
        }else if ([serviceName isEqualToString:SERVICENAME_LATESTLIST]){
            NSDictionary *resultDict = response.rawResponseDictionary;
            NSArray *responseArray = resultDict[@"result"][@"groupList"];
            Group *group = [[Group alloc] init];
            responseArray = [group loadArrayPropertyWithDataSource:responseArray requireModel:@"Group"];
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (Group *item in responseArray)
            {
                NSURL *coverUrl = [NSURL URLWithString:item.coverImgUrl];
                if ([coverUrl.scheme isEqualToString:@"http"] || [coverUrl.scheme isEqualToString:@"https"]) {
                    [tempArray addObject:item];
                }
            }
            LatestCollectionViewLayout *layout2 = (LatestCollectionViewLayout *)self.mLastestCollectionView.collectionViewLayout;
            NSMutableArray *temAry2 = nil;
            if (startLatest != 0) {
                temAry2 = [[NSMutableArray alloc]initWithArray:layout2.groupList];
            }else{
                temAry2 = [[NSMutableArray alloc]init];
            }
            [temAry2 addObjectsFromArray:tempArray];
            layout2.groupList = temAry2;
            [self.mLastestCollectionView reloadData];
            [self.mLastestCollectionView .mj_footer endRefreshing];
            [self.mLastestCollectionView .mj_header endRefreshing];
            isFirstTimeFetchDataLatest = NO;
        }else if ([serviceName isEqualToString:SERVICENAME_CATEGORYLIST]){
            NSDictionary *resultDict = response.rawResponseDictionary;
            NSArray *classificationlist = resultDict[@"result"][@"classificationlist"];
            Classification *group = [[Classification alloc] init];
            NSArray* responseArray = [group loadArrayPropertyWithDataSource:classificationlist requireModel:@"Classification"];
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (Classification *item in responseArray)
            {
                NSURL *coverUrl = [NSURL URLWithString:item.coverImgUrl];
                if ([coverUrl.scheme isEqualToString:@"http"] || [coverUrl.scheme isEqualToString:@"https"]) {
                    [tempArray addObject:item];
                }
            }
            self.mCategoryTableView.categoryList = tempArray;
            //reload data
            [self.mCategoryTableView reloadData];
            isFirstTimeFetchDataCategory = NO;
        }
    }else{
        [KVNProgress showErrorWithStatus:response.errorMessage];
        
        if ([serviceName isEqualToString:SERVICENAME_RECOMMENDEDLIST]) {
            [self.mRecommndCollectionView .mj_footer endRefreshing];
            [self.mRecommndCollectionView .mj_header endRefreshing];
            startRecommended -= 30;
            startRecommended = startRecommended >0 ? startRecommended :0;
        }else if ([serviceName isEqualToString:SERVICENAME_LATESTLIST]){
            [self.mLastestCollectionView .mj_footer endRefreshing];
            [self.mLastestCollectionView .mj_header endRefreshing];
            startLatest -= 30;
            startLatest = startLatest >0 ? startLatest :0;
        }
    }
    
}

-(void)categoryTableViewItemClicked:(NSIndexPath *)indexPath{
    SubCategoryViewController *subCategoryViewController = [[SubCategoryViewController alloc]initWithNibName:@"SubCategoryViewController_iphone" bundle:nil];
    subCategoryViewController.category = self.mCategoryTableView.categoryList[indexPath.row];
    [self.navigationController pushViewController:subCategoryViewController animated:YES];
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(RecommndCollectionView *)mRecommndCollectionView{
    if (!_mRecommndCollectionView) {
        RecommndCollectionViewLayout *layout1 = [[RecommndCollectionViewLayout alloc]initWithDelegate:self];
        _mRecommndCollectionView = [[RecommndCollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout1];
        _mRecommndCollectionView.delegate = layout1;
        _mRecommndCollectionView.dataSource = layout1;
        //load more data of recommend collection view
        __weak typeof(self) weakSelf = self;
        _mRecommndCollectionView.mj_footer =  [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            weakSelf.startRecommended = weakSelf.startRecommended + 30;
            NSString *startString = [NSString stringWithFormat:@"%i",weakSelf.startRecommended];
            WrapperServiceMediator *serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_RECOMMENDEDLIST params:@{@"start":startString}];
            [weakSelf doNetworkService:serviceMediator];
            [KVNProgress show];
        }];
        
        _mRecommndCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // remove all cache
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            weakSelf.startRecommended = 0;
            NSString *startString = [NSString stringWithFormat:@"%i",weakSelf.startRecommended];
            WrapperServiceMediator *serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_RECOMMENDEDLIST params:@{@"start":startString}];
            [weakSelf doNetworkService:serviceMediator];
            [KVNProgress show];
        }];
    }
    return _mRecommndCollectionView;
}


-(LatestCollectionView *)mLastestCollectionView{
    if (!_mLastestCollectionView) {
        //init latest
        LatestCollectionViewLayout *layout2 = [[LatestCollectionViewLayout alloc]initWithDelegate:self];
        _mLastestCollectionView = [[LatestCollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout2];
        _mLastestCollectionView.delegate = layout2;
        _mLastestCollectionView.dataSource = layout2;
        //load more data of latest collection view
        __weak typeof(self) weakSelf = self;
        _mLastestCollectionView .mj_footer =  [MJRefreshFooter footerWithRefreshingBlock:^{
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            weakSelf.startLatest = weakSelf.startLatest + 30;
            NSString *startString = [NSString stringWithFormat:@"%i",weakSelf.startLatest];
            WrapperServiceMediator *serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_LATESTLIST params:@{@"start":startString}];
            [weakSelf doNetworkService:serviceMediator];
            [KVNProgress show];
        }];
        
        _mLastestCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //remove all cache
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            weakSelf.startLatest = 0;
            NSString *startString = [NSString stringWithFormat:@"%i",weakSelf.startLatest];
            WrapperServiceMediator *serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_LATESTLIST params:@{@"start":startString}];
            [weakSelf doNetworkService:serviceMediator];
            [KVNProgress show];
        }];
    }
    return _mLastestCollectionView;
    
}

-(CategoryTableView *)mCategoryTableView{
    if (!_mCategoryTableView) {
        //init category
        _mCategoryTableView = [[CategoryTableView alloc]initWithFrame:self.view.frame];
        //    mCategoryTableView.backgroundColor = [UIColor colorWithHex:0xe2e3e3];
        _mCategoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mCategoryTableView.mDelegate = self;
        _mCategoryTableView.delegate = _mCategoryTableView;
        _mCategoryTableView.dataSource = _mCategoryTableView;
    }
    return _mCategoryTableView;
}


@end


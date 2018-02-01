//
//  CategoryViewController.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-24.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "SubCategoryViewController.h"
#import "RecommndCollectionView.h"
#import "LatestCollectionView.h"
#import "HotestCollectionView.h"
#import "ViewPager.h"
#import "ViewPagerAdapter.h"

#import "LatestCollectionViewLayout.h"
#import "RecommndCollectionViewLayout.h"
#import "HotestCollectionViewLayout.h"

#import "WrapperDetailViewController.h"
#import "WrapperServiceMediator.h"
#import "CateListViewController.h"

#import "ParamsModel.h"
#import "UIScrollView+MJRefresh.h"

#define TAG_BTN_OFFSET      89091
#define TAG_BTN_LATEST      89091
#define TAG_BTN_RECOMMEND   89092
#define TAG_BTN_HOTEST      89093
#define TAG_BTN_NAV_RIGHT   89094
#define TAG_BTN_NAV_LEFT    89095
#define TAG_BTN_NAV_TITLE   89096
/**
 * define current request type,total or subcategory
 */
typedef enum _CurrentCategoryType{
    CurrentCategoryTypeTotal,
    CurrentCategoryTypeSub
}CurrentCategoryType;

@interface SubCategoryViewController ()<ViewPagerDelegate,KSCollectionViewLayoutDelegate,CateListViewControllerDelegate>{
    RecommndCollectionView    *mRecommndCollectionView;
    LatestCollectionView      *mLastestCollectionView;
    HotestCollectionView      *mHotestCollectionView;
    
    __weak IBOutlet UIButton *recommendButton;
    __weak IBOutlet UIButton *latestButton;
    __weak IBOutlet UIButton *hotestButton;
    __weak IBOutlet UIView   *separatorView;
    
    UIButton *navigationBarTitleButton;
    
    ViewPager *mViewPager;
    //judge if get the sub category infomation
    
    UIButton *leftNavigationBarButton;
    UIButton *rightNavigationBarButton;
}
/**
 * These properties are used in block,so must declared as property,if not ,recycle reference should cause
 */
@property (nonatomic, assign) CurrentCategoryType type;
@property (nonatomic, assign) int startCategoryRecommended;
@property (nonatomic, assign) int startSecondaryCategoryRecommended;
@property (nonatomic, assign) int startCategoryLatest;
@property (nonatomic, assign) int startSecondaryCategoryLatest;
@property (nonatomic, assign) int startCategoryHottest;
@property (nonatomic, assign) int startSecondaryCategoryHottest;
//@property (nonatomic, assign) int shouldUpdateDataRecommend;
//@property (nonatomic, assign) int shouldUpdateDataLatest;
//@property (nonatomic, assign) int shouldUpdateDataHottest;

@property (nonatomic, assign) BOOL isFirstTimeFetchDataLatest;
@property (nonatomic, assign) BOOL isFirstTimeFetchDataHottest;
@property (nonatomic, assign) BOOL isFirstTimeFetchDataRecommended;

@property (weak, nonatomic) IBOutlet UIView *titleBarView;

@end

@implementation SubCategoryViewController

@synthesize type;
@synthesize startCategoryRecommended,startSecondaryCategoryRecommended;
@synthesize startCategoryLatest,startSecondaryCategoryLatest;
@synthesize startCategoryHottest,startSecondaryCategoryHottest;
//@synthesize shouldUpdateDataRecommend,shouldUpdateDataLatest,shouldUpdateDataHottest;
@synthesize isFirstTimeFetchDataLatest,isFirstTimeFetchDataHottest,isFirstTimeFetchDataRecommended;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.type = CurrentCategoryTypeTotal;
    // should update tag
    isFirstTimeFetchDataLatest = YES;
    isFirstTimeFetchDataHottest = YES;
    isFirstTimeFetchDataRecommended = YES;
    startCategoryRecommended = 0;
    startSecondaryCategoryRecommended = 0;
    startCategoryLatest = 0;
    startSecondaryCategoryLatest = 0;
    startCategoryHottest = 0;
    startSecondaryCategoryHottest = 0;
    separatorView.backgroundColor = [UIColor colorWithHex:0xc8c8c8];
    
    /**
     *  navigation bar left bar button
     */
    UIBarButtonItem *btnItem1 = [[UIBarButtonItem alloc]init];
    leftNavigationBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image1 = [UIImage imageNamed:@"nav_back"];
    [leftNavigationBarButton setBackgroundImage:image1 forState:UIControlStateNormal];
    [leftNavigationBarButton setFrame:CGRectMake(0, 0, 12, 21)];
    [leftNavigationBarButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftNavigationBarButton.tag = TAG_BTN_NAV_LEFT;
    [btnItem1 setCustomView:leftNavigationBarButton];
    self.navigationItem.leftBarButtonItem = btnItem1;
    
    /**
     * navigation bar right button
     */
    UIBarButtonItem *btnItem2 = [[UIBarButtonItem alloc]init];
    rightNavigationBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image2 = [UIImage imageNamed:@"nav_screen"];
    [rightNavigationBarButton setBackgroundImage:image2 forState:UIControlStateNormal];
    [rightNavigationBarButton setFrame:CGRectMake(0, 0, 17, 17)];
    [rightNavigationBarButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    rightNavigationBarButton.tag = TAG_BTN_NAV_RIGHT;
    [btnItem2 setCustomView:rightNavigationBarButton];
    self.navigationItem.rightBarButtonItem = btnItem2;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    /**
     * navigation bar title view
     */
    navigationBarTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    navigationBarTitleButton.frame= CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 44);
    [navigationBarTitleButton setTitle:@"壁纸宝贝" forState:UIControlStateNormal];
    [navigationBarTitleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navigationBarTitleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    navigationBarTitleButton.tag = TAG_BTN_NAV_TITLE;
    [navigationBarTitleButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = navigationBarTitleButton;
    /*
     * Button event binding
     */
    recommendButton.tag = TAG_BTN_RECOMMEND;
    latestButton.tag    = TAG_BTN_LATEST;
    hotestButton.tag  = TAG_BTN_HOTEST;
    [self setButtonHighlighed:latestButton];
    
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
    
    [hotestButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(recommendButton.mas_right).offset(60);
        make.top.mas_equalTo(0.f);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    [recommendButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [latestButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [hotestButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
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
            
            frame.size.height -= (88 + 30);
            frame.origin.y = (88 + 30);
        }else
        {
            frame.size.height -= (68 + 30);
            frame.origin.y = (68 + 30);
        }
    } else {
        frame.size.height -= (68 + 30);
        frame.origin.y = (68 + 30);
    }
    
    mViewPager = [[ViewPager alloc]initWithFrame:frame];
    mViewPager.mDelegate = self;
    [self.view addSubview:mViewPager];
    // Do any additional setup after loading the view from its nib.
    self.title = self.category.cateName;
    //init recommend
    RecommndCollectionViewLayout *layout1 = [[RecommndCollectionViewLayout alloc]initWithDelegate:self];
    mRecommndCollectionView = [[RecommndCollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout1];
    mRecommndCollectionView.delegate = layout1;
    mRecommndCollectionView.dataSource = layout1;
    //init latest
    LatestCollectionViewLayout *layout2 = [[LatestCollectionViewLayout alloc]initWithDelegate:self];
    mLastestCollectionView = [[LatestCollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout2];
    mLastestCollectionView.delegate = layout2;
    mLastestCollectionView.dataSource = layout2;
    //init hotest
    HotestCollectionViewLayout *layout3 = [[HotestCollectionViewLayout alloc]initWithDelegate:self];
    mHotestCollectionView = [[HotestCollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout3];
    mHotestCollectionView.delegate = layout3;
    mHotestCollectionView.dataSource = layout3;

    NSArray *array = [NSArray arrayWithObjects:mLastestCollectionView,mRecommndCollectionView,mHotestCollectionView, nil];
    adapter.views = array;
    [mViewPager setAdapter:adapter];
    
    /**
     * Add header view and footer view
     */
    __weak typeof(self) weakSelf = self;
    mRecommndCollectionView.mj_footer =  [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        WrapperServiceMediator *serviceMediator = nil;
        if (weakSelf.type == CurrentCategoryTypeTotal) {
            weakSelf.startCategoryRecommended = weakSelf.startCategoryRecommended + 30;
            NSString *startString = [NSString stringWithFormat:@"%i",weakSelf.startCategoryRecommended];
            ((ParamsModel *)[ParamsModel shareInstance]).start = startString;
            serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_CATEGORYRECOMMENDEDLIST];
        }else{
            weakSelf.startSecondaryCategoryRecommended = weakSelf.startSecondaryCategoryRecommended + 30;
            NSString *startString = [NSString stringWithFormat:@"%i",weakSelf.startSecondaryCategoryRecommended];
            ((ParamsModel *)[ParamsModel shareInstance]).start = startString;
            serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_SECONDARYCATEGORYRECOMMENDEDLIST];
        }
        [weakSelf doNetworkService:serviceMediator];
        [KVNProgress show];
    }];

    mRecommndCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        weakSelf.isFirstTimeFetchDataRecommended = YES;
        WrapperServiceMediator *serviceMediator = nil;
        if (weakSelf.type == CurrentCategoryTypeTotal) {
            weakSelf.startCategoryRecommended = 0;
            NSString *startString = [NSString stringWithFormat:@"%i",weakSelf.startCategoryRecommended];
            ((ParamsModel *)[ParamsModel shareInstance]).start = startString;
            serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_CATEGORYRECOMMENDEDLIST];
        }else{
            weakSelf.startSecondaryCategoryRecommended = 0;
            NSString *startString = [NSString stringWithFormat:@"%i",weakSelf.startSecondaryCategoryRecommended];
            ((ParamsModel *)[ParamsModel shareInstance]).start = startString;
            serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_SECONDARYCATEGORYRECOMMENDEDLIST];
        }
        [weakSelf doNetworkService:serviceMediator];
        [KVNProgress show];
    }];


    mLastestCollectionView.mj_footer =  [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        WrapperServiceMediator *serviceMediator = nil;
        if (weakSelf.type == CurrentCategoryTypeTotal) {
            weakSelf.startCategoryLatest = weakSelf.startCategoryLatest + 30;
            NSString *startString = [NSString stringWithFormat:@"%i",weakSelf.startCategoryLatest];
            ((ParamsModel *)[ParamsModel shareInstance]).start = startString;
            serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_CATEGORYLATESTLIST];
        }else{
            weakSelf.startSecondaryCategoryLatest = weakSelf.startSecondaryCategoryLatest + 30;
            NSString *startString = [NSString stringWithFormat:@"%i",weakSelf.startSecondaryCategoryLatest];
            ((ParamsModel *)[ParamsModel shareInstance]).start = startString;
            serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_SECONDARYCATEGORYLATESTLIST];
        }
        [weakSelf doNetworkService:serviceMediator];
        [KVNProgress show];
    }];

    mLastestCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isFirstTimeFetchDataLatest = YES;
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        WrapperServiceMediator *serviceMediator = nil;
        if (weakSelf.type == CurrentCategoryTypeTotal) {
            weakSelf.startCategoryLatest = 0;
            NSString *startString = [NSString stringWithFormat:@"%i",weakSelf.startCategoryLatest];
            ((ParamsModel *)[ParamsModel shareInstance]).start = startString;
            serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_CATEGORYLATESTLIST];
        }else{
            weakSelf.startSecondaryCategoryLatest = 0;
            NSString *startString = [NSString stringWithFormat:@"%i",weakSelf.startSecondaryCategoryLatest];
            ((ParamsModel *)[ParamsModel shareInstance]).start = startString;
            serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_SECONDARYCATEGORYLATESTLIST];
        }
        [weakSelf doNetworkService:serviceMediator];
        [KVNProgress show];
    }];

    mHotestCollectionView.mj_footer =  [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        WrapperServiceMediator *serviceMediator = nil;
        if (weakSelf.type == CurrentCategoryTypeTotal) {
            weakSelf.startCategoryHottest = weakSelf.startCategoryHottest + 30;
            NSString *startString = [NSString stringWithFormat:@"%i",weakSelf.startCategoryHottest];
            ((ParamsModel *)[ParamsModel shareInstance]).start = startString;
            serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_CATEGORYHOTESTLIST];
        }else{
            weakSelf.startSecondaryCategoryHottest = weakSelf.startSecondaryCategoryHottest + 30;
            NSString *startString = [NSString stringWithFormat:@"%i",weakSelf.startSecondaryCategoryHottest];
            ((ParamsModel *)[ParamsModel shareInstance]).start = startString;
            serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_SECONDARYCATEGORYHOTESTLIST];
        }
        [weakSelf doNetworkService:serviceMediator];
        [KVNProgress show];
    }];

    mHotestCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isFirstTimeFetchDataHottest = YES;
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        WrapperServiceMediator *serviceMediator = nil;
        if (weakSelf.type == CurrentCategoryTypeTotal) {
            weakSelf.startCategoryHottest = 0;
            NSString *startString = [NSString stringWithFormat:@"%i",weakSelf.startCategoryHottest];
            ((ParamsModel *)[ParamsModel shareInstance]).start = startString;
            serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_CATEGORYHOTESTLIST];
        }else{
            weakSelf.startSecondaryCategoryHottest = 0;
            NSString *startString = [NSString stringWithFormat:@"%i",weakSelf.startSecondaryCategoryHottest];
            ((ParamsModel *)[ParamsModel shareInstance]).start = startString;
            serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_SECONDARYCATEGORYHOTESTLIST];
        }
        [weakSelf doNetworkService:serviceMediator];
        [KVNProgress show];
    }];
    /**
     * Do request
     */
    [self buttonClicked:latestButton];
}

/*
 *   Button event
 */
-(void)buttonClicked:(UIButton *) button{
    [self.outOfNetworkView dismiss];
    switch (button.tag) {
        case TAG_BTN_RECOMMEND:{
            mViewPager.currentPage = 1;
            [self setButtonHighlighed:recommendButton];
            //request
            if (isFirstTimeFetchDataRecommended) {
                    WrapperServiceMediator *serviceMediator = nil;
                    self.startCategoryLatest = 0;
                    ((ParamsModel *)[ParamsModel shareInstance]).start = @"0";
                    if (type == CurrentCategoryTypeTotal) {
                        serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_CATEGORYRECOMMENDEDLIST];
                    }else{
                        serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_SECONDARYCATEGORYRECOMMENDEDLIST];
                    }
                    ((ParamsModel *)[ParamsModel shareInstance]).cateId = self.category.cateId;
                    [self doNetworkService:serviceMediator];
                    [KVNProgress show];
            }
        }
            break;
        case TAG_BTN_LATEST:{
            mViewPager.currentPage = 0;
            [self setButtonHighlighed:latestButton];
            //request
            if (isFirstTimeFetchDataLatest) {
                
                    WrapperServiceMediator *serviceMediator = nil;
                    ((ParamsModel *)[ParamsModel shareInstance]).start = @"0";
                    if (type == CurrentCategoryTypeTotal) {
                        serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_CATEGORYLATESTLIST];
                    }else{
                        serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_SECONDARYCATEGORYLATESTLIST];
                    }
                    ((ParamsModel *)[ParamsModel shareInstance]).cateId = self.category.cateId;
                    [self doNetworkService:serviceMediator];
                    [KVNProgress show];

                
            }
        }
            break;
        case TAG_BTN_HOTEST:{
            mViewPager.currentPage = 2;
            [self setButtonHighlighed:hotestButton];
            //request
            if (isFirstTimeFetchDataHottest) {
                    WrapperServiceMediator *serviceMediator = nil;
                    ((ParamsModel *)[ParamsModel shareInstance]).start = @"0";
                    if (type == CurrentCategoryTypeTotal) {
                        serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_CATEGORYHOTESTLIST];
                    }else{
                        serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_SECONDARYCATEGORYHOTESTLIST];
                    }
                    ((ParamsModel *)[ParamsModel shareInstance]).cateId = self.category.cateId;
                    [self doNetworkService:serviceMediator];
                    [KVNProgress show];
                
            }
        }
            break;
        case TAG_BTN_NAV_RIGHT:{
            CateListViewController *cateListViewController = [[CateListViewController alloc]initWithNibName:@"CateListViewController_iphone" bundle:nil];
            cateListViewController.mDelegate = self;
            cateListViewController.category = self.category;
            [self.navigationController presentViewController:cateListViewController animated:YES completion:^{}];
        }
            break;
        case TAG_BTN_NAV_LEFT:{
            [self.navigationController popViewControllerAnimated:YES];
        }
        case TAG_BTN_NAV_TITLE:{
            if (mViewPager.currentPage == 0) {
                [mLastestCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
            }else if (mViewPager.currentPage == 1){
                [mRecommndCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
            }else if (mViewPager.currentPage == 2){
                [mHotestCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
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
    [hotestButton setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    switch (button.tag) {
        case TAG_BTN_RECOMMEND:{
            [recommendButton setTitleColor:[UIColor colorWithHex:0x1fb1e8] forState:UIControlStateNormal];
        }
            break;
        case TAG_BTN_LATEST:{
            [latestButton setTitleColor:[UIColor colorWithHex:0x1fb1e8] forState:UIControlStateNormal];
        }
            break;
        case TAG_BTN_HOTEST:{
            [hotestButton setTitleColor:[UIColor colorWithHex:0x1fb1e8] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - ScrollView Delegate
-(void)viewPagerDidEndDecelerating:(ViewPager *)viewPager{
    NSInteger page = viewPager.currentPage;
    if (0 == page) {
        [self buttonClicked:latestButton];
    }else if (1== page){
        [self buttonClicked:recommendButton];
    }else if (2 == page){
        [self buttonClicked:hotestButton];
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
        RecommndCollectionViewLayout *layout1 = (RecommndCollectionViewLayout *)mRecommndCollectionView.collectionViewLayout;
        NSArray *groupList = layout1.groupList;
        Group *group = groupList[section *3 +row ];
        WrapperDetailViewController *detailViewController = [[WrapperDetailViewController alloc]initWithNibName:@"WrapperDetailViewController_iphone" bundle:nil];
        detailViewController.fromcontroller = FromControllerRecommended;
        detailViewController.group = group;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }else if ([layout isKindOfClass:[LatestCollectionViewLayout class]]) {
        NSInteger section = [indexPath section];
        NSInteger row = [indexPath row];
        LatestCollectionViewLayout *layout1 = (LatestCollectionViewLayout *)mLastestCollectionView.collectionViewLayout;
        NSArray *groupList = layout1.groupList;
        Group *group = groupList[section *3 +row ];
        WrapperDetailViewController *detailViewController = [[WrapperDetailViewController alloc]initWithNibName:@"WrapperDetailViewController_iphone" bundle:nil];
        detailViewController.fromcontroller = FromControllerLatest;
        detailViewController.group = group;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }else if ([layout isKindOfClass:[HotestCollectionViewLayout class]]) {
        NSInteger section = [indexPath section];
        NSInteger row = [indexPath row];
        HotestCollectionViewLayout *layout1 = (HotestCollectionViewLayout *)mHotestCollectionView.collectionViewLayout;
        NSArray *groupList = layout1.groupList;
        Group *group = groupList[section *3 +row];
        WrapperDetailViewController *detailViewController = [[WrapperDetailViewController alloc]initWithNibName:@"WrapperDetailViewController_iphone" bundle:nil];
        detailViewController.fromcontroller = FromControllerHotest;
        detailViewController.group = group;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
}

/**
 override get response
 @see 
 */
-(void)refreshData:(NSString *)serviceName response:(NetworkResponse *)response{
    [KVNProgress dismiss];
    [self.outOfNetworkView dismiss];
    if (response.errorCode == 0) {
        if ([serviceName isEqualToString:SERVICENAME_CATEGORYRECOMMENDEDLIST] ||[serviceName isEqualToString:SERVICENAME_SECONDARYCATEGORYRECOMMENDEDLIST] ) {

            NSArray *Aryresponse1 = response.response;
            NSMutableArray *Aryresponse = [[NSMutableArray alloc] init];
            for (Group *item in Aryresponse1)
            {
                NSURL *coverUrl = [NSURL URLWithString:item.coverImgUrl];
                if ([coverUrl.scheme isEqualToString:@"http"] || [coverUrl.scheme isEqualToString:@"https"]) {
                    [Aryresponse addObject:item];
                }
            }
            
            RecommndCollectionViewLayout *layout1 = (RecommndCollectionViewLayout *)mRecommndCollectionView.collectionViewLayout;
            NSMutableArray *temAry = nil ;
            if (isFirstTimeFetchDataRecommended) {
                temAry = [[NSMutableArray alloc]init];
            }else{
                temAry = [[NSMutableArray alloc]initWithArray:layout1.groupList];
            }
            isFirstTimeFetchDataRecommended = NO;
            [temAry addObjectsFromArray:Aryresponse];
            layout1.groupList = temAry;
            [mRecommndCollectionView reloadData];
            [mRecommndCollectionView.mj_footer endRefreshing];
            [mRecommndCollectionView.mj_header endRefreshing];
        }else if ([serviceName isEqualToString:SERVICENAME_CATEGORYLATESTLIST] || [serviceName isEqualToString:SERVICENAME_SECONDARYCATEGORYLATESTLIST]) {
            NSArray *Aryresponse1 = response.response;
            NSMutableArray *Aryresponse = [[NSMutableArray alloc] init];
            for (Group *item in Aryresponse1)
            {
                NSURL *coverUrl = [NSURL URLWithString:item.coverImgUrl];
                if ([coverUrl.scheme isEqualToString:@"http"] || [coverUrl.scheme isEqualToString:@"https"]) {
                    [Aryresponse addObject:item];
                }
            }
            
            LatestCollectionViewLayout *layout1 = (LatestCollectionViewLayout *)mLastestCollectionView.collectionViewLayout;
            NSMutableArray *temAry = nil ;
            if (isFirstTimeFetchDataLatest) {
                temAry = [[NSMutableArray alloc]init];
            }else{
                temAry = [[NSMutableArray alloc]initWithArray:layout1.groupList];
            }
            isFirstTimeFetchDataLatest = NO;
            [temAry addObjectsFromArray:Aryresponse];
            layout1.groupList = temAry;
            [mLastestCollectionView reloadData];
            [mLastestCollectionView .mj_footer endRefreshing];
            [mLastestCollectionView .mj_header endRefreshing];
        }else if ([serviceName isEqualToString:SERVICENAME_CATEGORYHOTESTLIST] ||[serviceName isEqualToString:SERVICENAME_SECONDARYCATEGORYHOTESTLIST]) {

            NSArray *Aryresponse1 = response.response;
            NSMutableArray *Aryresponse = [[NSMutableArray alloc] init];
            for (Group *item in Aryresponse1)
            {
                NSURL *coverUrl = [NSURL URLWithString:item.coverImgUrl];
                if ([coverUrl.scheme isEqualToString:@"http"] || [coverUrl.scheme isEqualToString:@"https"]) {
                    [Aryresponse addObject:item];
                }
            }
            
            HotestCollectionViewLayout *layout1 = (HotestCollectionViewLayout *)mHotestCollectionView.collectionViewLayout;
            NSMutableArray *temAry = nil ;
            if (isFirstTimeFetchDataHottest) {
                temAry = [[NSMutableArray alloc]init];
            }else{
                temAry = [[NSMutableArray alloc]initWithArray:layout1.groupList];
            }
            isFirstTimeFetchDataHottest = NO;
            [temAry addObjectsFromArray:Aryresponse];
            layout1.groupList = temAry;
            [mHotestCollectionView reloadData];
            [mHotestCollectionView .mj_footer endRefreshing];
            [mHotestCollectionView .mj_header endRefreshing];
        }
    }else{
        [KVNProgress showErrorWithStatus:response.errorMessage];
        __weak typeof(self) weakSelf = self;
        
        if ([serviceName isEqualToString:SERVICENAME_CATEGORYRECOMMENDEDLIST]){
            weakSelf.startCategoryRecommended -= 30;
            weakSelf.startCategoryRecommended = weakSelf.startCategoryRecommended < 0 ? 0 : weakSelf.startCategoryRecommended;
            [mRecommndCollectionView .mj_footer endRefreshing];
            [mRecommndCollectionView .mj_header endRefreshing];
        }else if([serviceName isEqualToString:SERVICENAME_SECONDARYCATEGORYRECOMMENDEDLIST] ){
            weakSelf.startSecondaryCategoryRecommended -= 30;
            weakSelf.startSecondaryCategoryRecommended = weakSelf.startSecondaryCategoryRecommended < 0 ? 0 : weakSelf.startSecondaryCategoryRecommended;
            [mRecommndCollectionView .mj_footer endRefreshing];
            [mRecommndCollectionView .mj_header endRefreshing];
        }else if ([serviceName isEqualToString:SERVICENAME_CATEGORYLATESTLIST]){
            weakSelf.startCategoryLatest -= 30;
            weakSelf.startCategoryLatest = weakSelf.startCategoryLatest < 0 ? 0 : weakSelf.startCategoryLatest;
            [mLastestCollectionView .mj_footer endRefreshing];
            [mLastestCollectionView .mj_header endRefreshing];
        }else if ([serviceName isEqualToString:SERVICENAME_SECONDARYCATEGORYLATESTLIST]){
            weakSelf.startSecondaryCategoryLatest -= 30;
            weakSelf.startSecondaryCategoryLatest = weakSelf.startSecondaryCategoryLatest < 0 ? 0 : weakSelf.startSecondaryCategoryLatest;
            [mLastestCollectionView .mj_footer endRefreshing];
            [mLastestCollectionView .mj_header endRefreshing];
        }else if ([serviceName isEqualToString:SERVICENAME_CATEGORYHOTESTLIST]){
            weakSelf.startCategoryHottest -= 30;
            weakSelf.startCategoryHottest = weakSelf.startCategoryHottest < 0 ? 0 : weakSelf.startCategoryHottest;
            [mHotestCollectionView .mj_footer endRefreshing];
            [mHotestCollectionView .mj_header endRefreshing];
        }else if ([serviceName isEqualToString:SERVICENAME_SECONDARYCATEGORYHOTESTLIST]){
            weakSelf.startSecondaryCategoryHottest -= 30;
            weakSelf.startSecondaryCategoryHottest = weakSelf.startSecondaryCategoryHottest < 0 ? 0 : weakSelf.startSecondaryCategoryHottest;
            [mHotestCollectionView .mj_footer endRefreshing];
            [mHotestCollectionView .mj_header endRefreshing];
        }
        
    }
    
}

#pragma mark - cateListViewControoler delegate
-(void)cateListViewControoler:(CateListViewController *)controller rowDidSeleced:(NSIndexPath *)indexPath secondaryCategory:(Classification *)category{
    if (nil != category && ![category.cateName isEqualToString:@"全部"]) {
        /**
         * Set current type is sub category
         */
        type = CurrentCategoryTypeSub;
        
        isFirstTimeFetchDataLatest = YES;
        isFirstTimeFetchDataRecommended = YES;
        isFirstTimeFetchDataHottest = YES;
        self.title = category.cateName;
        ((ParamsModel *)[ParamsModel shareInstance]).subId = category.cateId;
        ((ParamsModel *)[ParamsModel shareInstance]).cateId = self.category.cateId;
        //set button background color and request data
        UIButton *button = [[UIButton alloc]init];
        button.tag = mViewPager.currentPage + TAG_BTN_OFFSET;
        [self buttonClicked:button];
    }else{
        /**
         * Set current type is total
         */
        type = CurrentCategoryTypeTotal;
        
        isFirstTimeFetchDataLatest = YES;
        isFirstTimeFetchDataRecommended = YES;
        isFirstTimeFetchDataHottest = YES;
        self.title = category.cateName;
        //set button background color and request data
        UIButton *button = [[UIButton alloc]init];
        button.tag = mViewPager.currentPage + TAG_BTN_OFFSET;
        [self buttonClicked:button];
    }
    
}

-(void)viewPagerDidScroll:(ViewPager *)viewPager{
    CGFloat contentOffsetX = viewPager.scrollView.contentOffset.x;
    //if draged to the firstpage , we can show the menu
    if (contentOffsetX < -15) {
        [self.navigationController popViewControllerAnimated:YES];
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
                [self buttonClicked:hotestButton];
            }
                break;
                
            default:
                break;
        }
}

-(void)setTitle:(NSString *)title{
    [super setTitle:title];
    [navigationBarTitleButton setTitle:title forState:UIControlStateNormal];
}


@end

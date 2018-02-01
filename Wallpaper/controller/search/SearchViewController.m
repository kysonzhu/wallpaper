//
//  SearchViewController.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-25.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchHistoryAdapter.h"
#import "SearchDetailViewController.h"
#import "WrapperServiceMediator.h"

#import "UserCenter.h"
#import "Group.h"

#define HEIGHT_SEARCHBAR 40
#define HEIGHT_STATUS_BAR 44
#define OFFSET_ORIGIN_DISPLAYTABLEVIEW 8
#define OFFSET_SEARCHBAR 7

#define TAG_BTN_NAV_LEFT    8910
#define TAG_BTN_CLEARCACHE  8911


@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,SearchHistoryAdapterDelegate>{
    UISearchBar         *mSearchBar;
    __weak IBOutlet UIView              *separaterView;
    
    __weak IBOutlet UITableView *historyTableView;
    
    SearchHistoryAdapter        *mAdapter;
    UIButton *leftNavigationBarButton;
        
    UISearchDisplayController *searchDisplayController;
}

@property (nonatomic, retain) NSArray *groupList;
@property (nonatomic, copy) NSString *searchWord;

@end

@implementation SearchViewController


- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"搜索";

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
    
    mSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, HEIGHT_SEARCHBAR)];
    mSearchBar.delegate = self;
    [mSearchBar setPlaceholder:@"搜索列表"];
    
    //clear cache
//    clearCacheButton.tag = TAG_BTN_CLEARCACHE;
//    [clearCacheButton setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
//    [clearCacheButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    separaterView.backgroundColor = [UIColor colorWithHex:0xc8c8c8];
    
    /**
     * adapter must be setted as a property or member valiable
     */
    mAdapter = [[SearchHistoryAdapter alloc]initWithTableView:historyTableView];
    mAdapter.mDelegate = self;
    mAdapter.historyDataList = [[UserCenter shareInstance] getSearchHistoryData];
    historyTableView.delegate = mAdapter;
    historyTableView.dataSource = mAdapter;
    historyTableView.tableHeaderView = mSearchBar;
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:mSearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [super viewWillDisappear:animated];

}

/**
 * buttonclick event
 */
-(void)buttonClicked:(UIButton *)button{
    switch (button.tag) {
        case TAG_BTN_NAV_LEFT:{
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case TAG_BTN_CLEARCACHE:{
            [[UserCenter shareInstance] clearSearchHistoryData];
            mAdapter.historyDataList = [[UserCenter shareInstance] getSearchHistoryData];
            [historyTableView reloadData];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = _groupList.count;
    if (count <= 10) {
        return count;
    }
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"a"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"a"];
    }
    Group *group = _groupList[indexPath.row];
    cell.textLabel.text = group.gName;
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchDetailViewController *detailViewController = [[SearchDetailViewController alloc]initWithNibName:@"SearchDetailViewController_iphone" bundle:nil];
    Group *group = _groupList[indexPath.row];
    self.searchWord = group.gName;
    detailViewController.searchText = self.searchWord;
    [self.navigationController pushViewController:detailViewController animated:YES];
}


#pragma mark - SearchHistoryAdapterDelegate
-(void)searchHistoryAdapter:(SearchHistoryAdapter *)adapter itemClicked:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    mSearchBar.text = [[UserCenter shareInstance]getSearchHistoryData][row-1];
    //search detail
    SearchDetailViewController *detailViewController = [[SearchDetailViewController alloc]initWithNibName:@"SearchDetailViewController_iphone" bundle:nil];
    detailViewController.searchText = mSearchBar.text;
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

-(void)searchHistoryAdapterClearHistoryButtonClicked:(SearchHistoryAdapter *)adapter{
    [[UserCenter shareInstance] clearSearchHistoryData];
    mAdapter.historyDataList = [[UserCenter shareInstance] getSearchHistoryData];
    [historyTableView reloadData];
}



-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    SearchDetailViewController *detailViewController = [[SearchDetailViewController alloc]initWithNibName:@"SearchDetailViewController_iphone" bundle:nil];
    self.searchWord = searchBar.text;
    detailViewController.searchText = self.searchWord;
    [self.navigationController pushViewController:detailViewController animated:YES];
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    _searchWord = searchText;
    /**
     * Do request
     */
    WrapperServiceMediator *serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_SEARCHGETSEARCHRESULTLIST];
    ((ParamsModel *)[ParamsModel shareInstance]).start = @"0";
    ((ParamsModel *)[ParamsModel shareInstance]).word = searchText;
    [self doNetworkService:serviceMediator];
}

-(void)refreshData:(NSString *)serviceName response:(NetworkResponse *)response{
    self.groupList = response.response;
    [searchDisplayController.searchResultsTableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSearchWord:(NSString *)searchWord{
    _searchWord = searchWord;
    [[UserCenter shareInstance] addSearchHistoryData:_searchWord];
    //refresh history data
    mAdapter.historyDataList = [[UserCenter shareInstance] getSearchHistoryData];
    [historyTableView reloadData];
}



@end

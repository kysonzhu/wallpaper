//
//  CateListViewController.m
//  WallWrapper ( https://github.com/kysonzhu/wallpaper.git )
//
//  Created by zhujinhui on 14-12-31.
//  Copyright (c) 2014年 zhujinhui( http://kyson.cn ). All rights reserved.
//

#import "CateListViewController.h"
#import "CateListItemCell.h"
#import "WrapperServiceMediator.h"

#define TAG_BTN_NAV_RIGHT   89094

@interface CateListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    __weak IBOutlet UITableView *mTableView;
    UIButton *rightNavigationBarButton;
}

@property (nonatomic, strong)    NSArray *classficationList;

@end

@implementation CateListViewController

static NSString *CategoryListItemCellReuseIdentifier = @"CategoryListItemCellReuseIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    mTableView.dataSource = self;
    mTableView.delegate = self;
    
    /**
     * navigation bar right button
     */
    UIBarButtonItem *btnItem2 = [[UIBarButtonItem alloc]init];
    rightNavigationBarButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightNavigationBarButton setTitle:@"关闭" forState:UIControlStateNormal];
    [rightNavigationBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightNavigationBarButton setFrame:CGRectMake(0, 0, 37, 37)];
    [rightNavigationBarButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    rightNavigationBarButton.tag = TAG_BTN_NAV_RIGHT;
    [btnItem2 setCustomView:rightNavigationBarButton];
    UINavigationItem *item = [[UINavigationItem alloc]init];
    item.rightBarButtonItem = btnItem2 ;
    self.navigationItem.rightBarButtonItem = btnItem2;
    
    _classficationList = [[NSArray alloc]init];
    //register nib
    UINib *cellNib = [UINib nibWithNibName:@"CateListItemCell" bundle:nil];
    [mTableView registerNib:cellNib forCellReuseIdentifier:CategoryListItemCellReuseIdentifier];
    //other
    WrapperServiceMediator *serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_CATEGORYSECONDARY params:@{@"fatherId":self.category.cateId}];
    [self doNetworkService:serviceMediator];
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Classification *category = _classficationList[indexPath.row];
    CateListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CategoryListItemCellReuseIdentifier];
    cell.titleLabel.text = category.cateName;
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _classficationList.count;
}


-(void)refreshData:(NSString *)serviceName response:(MGNetwokResponse *)response{
    if ([serviceName isEqualToString:SERVICENAME_CATEGORYSECONDARY]) {
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
        self.classficationList = tempArray;
        [mTableView reloadData];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Classification *category = _classficationList[indexPath.row];
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(cateListViewControoler:rowDidSeleced:secondaryCategory:)]) {
        [self.mDelegate cateListViewControoler:self rowDidSeleced:indexPath secondaryCategory:category];
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];

   
}

-(void)setClassficationList:(NSArray *)classficationList{
    Classification *classification = [[Classification alloc]init];
    classification.cateName = @"全部";
    NSMutableArray *tempAry = [[NSMutableArray alloc]init];
    [tempAry addObject:classification];
    [tempAry addObjectsFromArray:classficationList];
    _classficationList = tempAry;
}

/**
 * button click
 */
-(void)buttonClicked:(UIButton *)button{
    switch (button.tag) {
        case TAG_BTN_NAV_RIGHT:{
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
        }
            break;
            
        default:
            break;
    }
}

@end

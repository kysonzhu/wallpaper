//
//  CateListViewController.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-31.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
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
    
    CGRect rect = [UIScreen mainScreen].bounds;
    UINavigationBar *navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, 64)];
    [self.view addSubview:navigationBar];
    
    /**
     * navigation bar right button
     */
    UIBarButtonItem *btnItem2 = [[UIBarButtonItem alloc]init];
    rightNavigationBarButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightNavigationBarButton setTitle:@"关闭" forState:UIControlStateNormal];
//    [rightNavigationBarButton setTitle:@"关闭" forState:UIControlStateHighlighted];
    [rightNavigationBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightNavigationBarButton setFrame:CGRectMake(0, 0, 37, 37)];
    [rightNavigationBarButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    rightNavigationBarButton.tag = TAG_BTN_NAV_RIGHT;
    [btnItem2 setCustomView:rightNavigationBarButton];
    UINavigationItem *item = [[UINavigationItem alloc]init];
    item.rightBarButtonItem = btnItem2 ;
    [navigationBar pushNavigationItem:item animated:NO];
    
    _classficationList = [[NSArray alloc]init];
    //register nib
    UINib *cellNib = [UINib nibWithNibName:@"CateListItemCell" bundle:nil];
    [mTableView registerNib:cellNib forCellReuseIdentifier:CategoryListItemCellReuseIdentifier];
    
    //other
    WrapperServiceMediator *serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_CATEGORYSECONDARY];
    ((ParamsModel *)[ParamsModel shareInstance]).fatherId = self.category.cateId;
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


-(void)refreshData:(NSString *)serviceName response:(NetworkResponse *)response{
    if ([serviceName isEqualToString:SERVICENAME_CATEGORYSECONDARY]) {
        NSArray *aryResponse = response.response;
        self.classficationList = aryResponse;
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

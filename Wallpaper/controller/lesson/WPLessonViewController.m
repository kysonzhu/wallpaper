//
//  WPLessonViewController.m
//  Wallpaper
//
//  Created by kyson on 29/03/2018.
//  Copyright © 2018 zhujinhui. All rights reserved.
//

#import "WPLessonViewController.h"
#import <Masonry/Masonry.h>
#import "WPLessonTableViewCell.h"
#import "WPWebViewController.h"

@interface WPLessonViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UIButton *leftNavigationBarButton;
}

@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) NSArray    *dataArray;

@end

@implementation WPLessonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频教程";
    // Do any additional setup after loading the view from its nib.
    [self handleNavigationWithScrollView:self.tableView];

    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.view);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 250.f;
    
    /**
     *  navigation bar left bar button
     */
    UIBarButtonItem *btnItem1 = [[UIBarButtonItem alloc]init];
    leftNavigationBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image1 = [UIImage imageNamed:@"icon_navi_back"];
    [leftNavigationBarButton setBackgroundImage:image1 forState:UIControlStateNormal];
    [leftNavigationBarButton setFrame:CGRectMake(0, 0, 20, 21)];
    @weakify(self);
    [[leftNavigationBarButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [btnItem1 setCustomView:leftNavigationBarButton];
    self.navigationItem.leftBarButtonItem = btnItem1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WPLessonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nil"];
    if (!cell) {
        cell = [WPLessonTableViewCell loadFromXib];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPWebViewController *webViewController = [[WPWebViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webViewController];
    webViewController.loadingURL = @"https://gslb.miaopai.com/stream/W5Vgg4OwjLIHFEtZ4yoD0-GhzUxzFm2sdOOBeA__.mp4";
    [self showDetailViewController:nav sender:nil];

}


-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[@"小菲菲",@"闫策",@"姚怀广",@"朱金辉"];
    }
    return _dataArray;
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}

@end

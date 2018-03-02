//
//  AboutUsViewController.m
//  WallWrapper ( https://github.com/kysonzhu/wallpaper.git )
//
//  Created by zhujinhui on 14-12-24.
//  Copyright (c) 2014年 zhujinhui( http://kyson.cn ). All rights reserved.
//

#import "AboutUsViewController.h"
#import "WPAboutUsTableViewHeaderView.h"
#define TAG_BTN_NAV_LEFT 1090


@interface AboutUsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    __weak IBOutlet UILabel *rightsDetailLabel;
    __weak IBOutlet UILabel *statementLabel;
    
    __weak IBOutlet UILabel *versionLabel;
    
    UIButton *leftNavigationBarButton;
}
@property (weak, nonatomic) IBOutlet UIImageView *logoIcon;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray    *titles;
@property (nonatomic, strong)WPAboutUsTableViewHeaderView *headerView;

@end

@implementation AboutUsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self handleNavigationWithScrollView:self.tableView];
	// Do any additional setup after loading the view.
    self.title = @"关于我们";
    [self.logoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(100);
        make.size.mas_equalTo(CGSizeMake(83, 83));
    }];
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([WPAboutUsTableViewHeaderView headerHeight]);
        make.width.equalTo(self.headerView.superview);
    }];
//    self.tableView mas_mak
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.view);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 44.f;
    
    /**
     *  navigation bar left bar button
     */
    UIBarButtonItem *btnItem1 = [[UIBarButtonItem alloc]init];
    leftNavigationBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image1 = [UIImage imageNamed:@"icon_navi_back"];
    [leftNavigationBarButton setBackgroundImage:image1 forState:UIControlStateNormal];
    [leftNavigationBarButton setFrame:CGRectMake(0, 0, 20, 21)];
    [leftNavigationBarButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftNavigationBarButton.tag = TAG_BTN_NAV_LEFT;
    [btnItem1 setCustomView:leftNavigationBarButton];
    self.navigationItem.leftBarButtonItem = btnItem1;
    
    rightsDetailLabel.textColor = [UIColor colorWithHex:0x333333];
    statementLabel.textColor = [UIColor colorWithHex:0x333333];
    
    versionLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    [versionLabel addGestureRecognizer:tap];
}



-(void)buttonClicked:(UIButton *)button{
    switch (button.tag) {
        case TAG_BTN_NAV_LEFT:{
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapped:(UITapGestureRecognizer *)gesture{
    static int count = 0;
    if (count == 10) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"表白" message:@"Yanyufei我爱你!" delegate:nil cancelButtonTitle:@"接受" otherButtonTitles:@"接受", nil];
        [alert show];
        count = 0;
    }
    ++count;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return @"基本信息";
        }
            break;
        case 1:{
            return @"鸣谢";
        }
            
        default:
            break;
    }
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 1;
        }
            break;
        case 1:{
            return self.titles.count;
        }
            
        default:
            break;
    }
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nil"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"nil"];
    }
    
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                    cell.textLabel.text = [NSString stringWithFormat:@"版本号:    %@",version];
                }
                    break;
                case 1:
                {
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            cell.textLabel.text = self.titles[indexPath.row];
        }
            break;
        default:
            break;
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
    }
    return _tableView;
}

-(NSArray *)titles{
    if (!_titles) {
        _titles = @[@"小菲菲",@"闫策",@"姚怀广",@"朱金辉"];
    }
    return _titles;
}


-(WPAboutUsTableViewHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [WPAboutUsTableViewHeaderView loadFromXib];
    }
    return _headerView;
}

@end

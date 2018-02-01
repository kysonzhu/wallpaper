//
//  AboutUsViewController.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-24.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "AboutUsViewController.h"

#define TAG_BTN_NAV_LEFT 1090

@interface AboutUsViewController (){
    __weak IBOutlet UILabel *rightsDetailLabel;
    __weak IBOutlet UILabel *statementLabel;
    
    __weak IBOutlet UILabel *versionLabel;
    
    UIButton *leftNavigationBarButton;
}
@property (weak, nonatomic) IBOutlet UIImageView *logoIcon;

@end

@implementation AboutUsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"关于我们";
    [self.logoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(100);
        make.size.mas_equalTo(CGSizeMake(83, 83));
    }];
    
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

@end

//
//  WPNavigationController.m
//  Wallpaper
//
//  Created by kyson on 14/03/2018.
//  Copyright © 2018 zhujinhui. All rights reserved.
//

#import "WPNavigationController.h"

@interface WPNavigationController ()

@end

@implementation WPNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


// 控制状态栏的现实与隐藏
- (BOOL)prefersStatusBarHidden{
    UIViewController *vc = self.topViewController ;
    return vc.prefersStatusBarHidden;
}

-(UIViewController *)childViewControllerForStatusBarStyle{
    UIViewController *vc = self.topViewController ;
    return vc;
}



@end

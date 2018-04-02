//
//  WPNavigationController.m
//  Wallpaper
//
//  Created by kyson on 14/03/2018.
//  Copyright © 2018 zhujinhui. All rights reserved.
//

#import "WPNavigationController.h"
#import "EnvironmentConfigure.h"
@import GoogleMobileAds;

@interface WPNavigationController ()

@property(nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation WPNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    BOOL hasBuyed = [[NSUserDefaults standardUserDefaults] boolForKey:kHasBuySuccess];
    if (!hasBuyed) {
        self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-7896672979027584/3984670568"];
        GADRequest *request = [GADRequest request];
        [self.interstitial loadRequest:request];
        //延迟执行
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 30 * NSEC_PER_SEC); //设置时间2秒
        dispatch_after(time, dispatch_get_main_queue(), ^{
            if (self.interstitial.isReady)
                [self.interstitial presentFromRootViewController:self.topViewController];
        });
        

    }
    
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 10.1 )
    {
        if ([EnvironmentConfigure shareInstance].startAppTime == 2 || [EnvironmentConfigure shareInstance].startAppTime == 20 || [EnvironmentConfigure shareInstance].startAppTime == 200) {
            [SKStoreReviewController requestReview];
        }
    }
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

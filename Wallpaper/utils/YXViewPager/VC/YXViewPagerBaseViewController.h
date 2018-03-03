//
//  YXViewPagerBaseViewController.h
//  Pods
//
//  Created by yixiang on 17/3/29.
//
//

#import <UIKit/UIKit.h>

@interface YXViewPagerBaseViewController : UIViewController

@property (nonatomic, strong) NSDictionary *rootToSubInfo;

- (NSDictionary *)getPageConfigInfo;

- (void)renderUI;

@end

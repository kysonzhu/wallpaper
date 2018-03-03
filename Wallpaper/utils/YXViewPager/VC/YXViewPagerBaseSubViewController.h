//
//  YXViewPagerBaseSubViewController.h
//  Pods
//
//  Created by yixiang on 17/3/29.
//
//

#import <UIKit/UIKit.h>
#import "YXViewPagerEventDelegate.h"

@interface YXViewPagerBaseSubViewController : UIViewController

/**
 RootVC向SubVC传递的消息参数
 */
@property (nonatomic, strong) NSDictionary *rootToSubInfo;

//RootVC类作为SubVC类的代理 处理一些需要子类传给父类的消息
@property (nonatomic, weak) id<YXViewPagerEventDelegate> delegate;

//在SubVC类中获取rootVc，主要用于跳转
@property (nonatomic, strong) UIViewController *rootVc;

@end

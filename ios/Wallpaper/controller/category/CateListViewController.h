//
//  CateListViewController.h
//  WallWrapper ( https://github.com/kysonzhu/wallpaper.git )
//
//  Created by zhujinhui on 14-12-31.
//  Copyright (c) 2014年 zhujinhui( http://kyson.cn ). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Classification.h"
#import "WPBaseViewController.h"

@protocol CateListViewControllerDelegate ;

@interface CateListViewController : WPBaseViewController

@property (nonatomic, assign) id<CateListViewControllerDelegate> mDelegate;

@property (nonatomic, strong) Classification *category;

@end

@protocol CateListViewControllerDelegate <NSObject>

-(void)cateListViewControoler:(CateListViewController *) controller rowDidSeleced:(NSIndexPath *)indexPath secondaryCategory:(Classification *) category;

@end

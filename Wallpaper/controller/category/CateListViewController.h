//
//  CateListViewController.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-31.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Classification.h"

@protocol CateListViewControllerDelegate ;


@interface CateListViewController : Controller

@property (nonatomic, assign) id<CateListViewControllerDelegate> mDelegate;

@property (nonatomic, strong) Classification *category;

@end

@protocol CateListViewControllerDelegate <NSObject>

-(void)cateListViewControoler:(CateListViewController *) controller rowDidSeleced:(NSIndexPath *)indexPath secondaryCategory:(Classification *) category;

@end
//
//  CategoryTableView.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-30.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CategoryTableViewDelegate;

@interface CategoryTableView : UITableView<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, assign) id<CategoryTableViewDelegate> mDelegate;

@property (nonatomic,retain) NSArray *categoryList;

@end

@protocol CategoryTableViewDelegate <NSObject>

-(void)categoryTableViewItemClicked:(NSIndexPath *) indexPath;

@end
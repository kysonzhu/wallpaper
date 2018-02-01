//
//  SearchHistoryDataSource.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 15-1-4.
//  Copyright (c) 2015年 zhujinhui. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SearchHistoryAdapterDelegate;

@interface SearchHistoryAdapter : NSObject<UITableViewDataSource,UITableViewDelegate>{
}

@property (nonatomic, assign) id<SearchHistoryAdapterDelegate> mDelegate;
@property (nonatomic, strong) NSArray *historyDataList;

- (id)initWithTableView:(UITableView *)tableView;

@end

@protocol SearchHistoryAdapterDelegate <NSObject>

-(void)searchHistoryAdapter:(SearchHistoryAdapter *)adapter itemClicked:(NSIndexPath *) indexPath;

-(void)searchHistoryAdapterClearHistoryButtonClicked:(SearchHistoryAdapter *)adapter ;


@end


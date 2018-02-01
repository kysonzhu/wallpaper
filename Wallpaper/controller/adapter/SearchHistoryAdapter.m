//
//  SearchHistoryDataSource.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 15-1-4.
//  Copyright (c) 2015年 zhujinhui. All rights reserved.
//

#import "SearchHistoryAdapter.h"
#import "SearchHistoryItemCell.h"
#import "SearchClearHistoryItemCell.h"

@interface SearchHistoryAdapter(){
    
}

@property (nonatomic, weak) UITableView *tableView;

@end
static NSString *SearchHistoryItemCellReuseIdentifier = @"SearchHistoryItemCellReuseIdentifier";
static NSString *SearchClearHistoryItemCellReuseIdentifier = @"SearchClearHistoryItemCellReuseIdentifier";

@implementation SearchHistoryAdapter

- (id)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        self.tableView = tableView;
        UINib *nib = [UINib nibWithNibName:@"SearchHistoryItemCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:SearchHistoryItemCellReuseIdentifier];
        
        UINib *nib2 = [UINib nibWithNibName:@"SearchClearHistoryItemCell" bundle:nil];
        [_tableView registerNib:nib2 forCellReuseIdentifier:SearchClearHistoryItemCellReuseIdentifier];
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_historyDataList.count >=5) {
        return 5;
    }
    return _historyDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (0 != indexPath.row) {
        cell = [tableView dequeueReusableCellWithIdentifier:SearchHistoryItemCellReuseIdentifier];
        SearchHistoryItemCell *cell1 = (SearchHistoryItemCell*) cell;

        cell1.titleLabel.text = _historyDataList[indexPath.row];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:SearchClearHistoryItemCellReuseIdentifier];
        SearchClearHistoryItemCell *cell2 = (SearchClearHistoryItemCell*) cell;
        [cell2.clearCacheButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(searchHistoryAdapter:itemClicked:)]) {
            [self.mDelegate searchHistoryAdapter:self itemClicked:indexPath];
        }
    }
    
}


-(void)buttonClicked:(UIButton *) button{
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(searchHistoryAdapterClearHistoryButtonClicked:)]) {
        [self.mDelegate searchHistoryAdapterClearHistoryButtonClicked:self];
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 0) {
        cell.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
        [UIView animateWithDuration:0.7 animations:^{
            cell.frame = CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
        } completion:^(BOOL finished) {
            ;
        }];
    }
}

-(void)setHistoryDataList:(NSArray *)historyDataList{
    if (nil != historyDataList && historyDataList.count > 0) {
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        [tempArray addObject:@"清除历史"];
        [tempArray addObjectsFromArray:historyDataList];
        _historyDataList =tempArray;
    }else{
        _historyDataList = nil;
    }
}


@end

//
//  CategoryTableView.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-30.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "CategoryTableView.h"
#import "CategoryTableViewCell.h"
#import "Classification.h"

@implementation CategoryTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = nil;
        self.backgroundColor = [UIColor whiteColor];
        
        // Initialization code
        UINib *tableViewCellNib = [UINib nibWithNibName:@"CategoryTableViewCell" bundle:nil];
        [self registerNib:tableViewCellNib forCellReuseIdentifier:@"CategoryTableViewCellReuseIdentifier"];
    }
    return self;
}

#pragma mark - uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_categoryList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Classification *category = _categoryList[indexPath.row];
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryTableViewCellReuseIdentifier"];
    cell.cateNameLabel.text = category.cateName;
    cell.cateDetailLabel.text = category.keyword;
    [cell.coverImageView loadImage:category.coverImgUrl];
    
    return cell;
}


#pragma mark - uitablview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.mDelegate &&[self.mDelegate respondsToSelector:@selector(categoryTableViewItemClicked:)]) {
        [self.mDelegate categoryTableViewItemClicked:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


@end

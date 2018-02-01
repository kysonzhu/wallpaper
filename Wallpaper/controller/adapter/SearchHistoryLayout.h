//
//  SearchHistoryLayout.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 15-1-4.
//  Copyright (c) 2015年 zhujinhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchHistoryLayoutDelegate;

@interface SearchHistoryLayout : UICollectionViewFlowLayout<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic ,weak) id<SearchHistoryLayoutDelegate> mDelegate;

@property (nonatomic, strong) NSArray *groupList;


-(id)initWithDelegate:(id<SearchHistoryLayoutDelegate>) delegate;


@end


@protocol SearchHistoryLayoutDelegate <NSObject>

-(void)searchHistoryLayout:(SearchHistoryLayout *) layout itemDidClicked:(NSIndexPath *)indexPath;

@end
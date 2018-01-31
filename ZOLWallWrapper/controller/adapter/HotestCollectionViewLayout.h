//
//  HotestCollectionViewLayout.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-30.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSCollectionViewLayout.h"

@interface HotestCollectionViewLayout : KSCollectionViewLayout<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) NSArray *groupList;


@end

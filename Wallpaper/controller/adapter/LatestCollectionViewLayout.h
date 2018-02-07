//
//  LatestCollectionViewLayout.h
//  WallWrapper ( https://github.com/kysonzhu/wallpaper.git )
//
//  Created by zhujinhui on 14-12-23.
//  Copyright (c) 2014年 zhujinhui( http://kyson.cn ). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSCollectionViewLayout.h"

@interface LatestCollectionViewLayout : KSCollectionViewLayout<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>


@property (nonatomic,strong) NSArray *groupList;


@end

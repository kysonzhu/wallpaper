//
//  KSCollectionView.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-22.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSCollectionView : UICollectionView





@property (nonatomic, strong) UIViewController *controller;

-(id)initWithController:(UIViewController *) controller;

@end

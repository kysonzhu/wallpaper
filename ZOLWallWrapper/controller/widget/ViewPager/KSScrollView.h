//
//  KSScrollView.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 15-1-15.
//  Copyright (c) 2015年 zhujinhui. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol KSScrollViewDelegate;


@interface KSScrollView : UIScrollView

@property (nonatomic, assign) id<KSScrollViewDelegate> mDelegate;


@end


@protocol KSScrollViewDelegate <NSObject>

-(void)ksScrollViewItemDidClicked:(KSScrollView *) scrollview;


@end
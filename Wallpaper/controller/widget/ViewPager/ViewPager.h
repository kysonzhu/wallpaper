//
//  ViewPager.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-19.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewPagerAdapter.h"
#import "KSScrollView.h"

#define HEIGHT_VIEWPAGER ([UIScreen mainScreen].bounds.size.height)


@protocol ViewPagerDelegate;

@interface ViewPager : UIView<UIScrollViewDelegate>

@property (assign ,nonatomic) id<ViewPagerDelegate> mDelegate;

@property (nonatomic, retain) NSArray *imageUrls;

@property (nonatomic, retain) NSArray *imageNames;

@property (nonatomic,assign,readonly) NSInteger page;

@property (nonatomic,retain) ViewPagerAdapter *adapter;

@property (nonatomic, assign) NSInteger currentPage;


-(UIView *)viewAtIndex:(NSInteger) page;

-(KSScrollView *)scrollView;

@end


/**
 * the protocol of the ViewPager
 */
@protocol ViewPagerDelegate <NSObject>

@optional
-(void)viewPagerItemDidClicked:(int)index imageName:(NSString *)imageName imageUrl:(NSString *)imageUrl;

-(void)viewPagerDidScroll:(ViewPager *)viewPager ;

-(void)viewPagerDidEndDecelerating:(ViewPager *)viewPager ;

@optional
//-(void)viewPagerDidScroll:(GalleryView *)gallery;


@end

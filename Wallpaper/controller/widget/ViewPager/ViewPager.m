//
//  ViewPager.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-19.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "ViewPager.h"
#import "AutoLoadImageView.h"
#import "UserCenter.h"
#import "FileManager.h"
#import <Masonry/Masonry.h>

#define TAG_BTN_OFFSET 12347

@interface ViewPager ()<UIScrollViewDelegate,KSScrollViewDelegate>{
    
    KSScrollView *_scrollView;
    __weak IBOutlet KSScrollView *mScrollView;
    BOOL hasTapActionReceived;
    
    NSInteger times;
    NSInteger originImageCount;
}

@end


@implementation ViewPager
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(id)init{
    NSLog(@"use initWithFrame instead");
    return nil;
}

/**
 * init scroll View
 */
-(void)initScrollView{
    [self.scrollView setPagingEnabled:YES];
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
//    self.scrollView.contentInset = UIEdgeInsetsMake(97, 0, 0, 0);
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
    }
    
    [self addSubview:self.scrollView];
}

-(void)setAdapter:(ViewPagerAdapter *)adapter{
    _adapter = adapter;
    self.currentPage = 0;
    
    [self initScrollView];
    
    NSUInteger count = [adapter numberOfPages:self];
    [self.scrollView setContentSize:CGSizeMake(self.frame.size.width * count, self.frame.size.height)];
    
    // remove all subviews
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    //add subviews
    for (int i = 0 ; i < count; ++i) {
        UIView *view = [adapter getItem:i];
        view.tag = TAG_BTN_OFFSET + i;
        [self.scrollView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(i * self.frame.size.width);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.width.mas_equalTo(self.frame.size.width);
        }];
    }
    
}




-(void)setImageUrls:(NSArray *)imageUrls{
    _imageNames = nil;
    _imageUrls = imageUrls;
    originImageCount = _imageUrls.count;
    self.currentPage = 0;
    [self initScrollView];
    
    NSInteger imageCount = imageUrls.count;
    CGRect appFrame = [UIScreen mainScreen].applicationFrame;
    float screenWidth = appFrame.size.width;
    //content size
    [self.scrollView setContentSize:CGSizeMake(appFrame.size.width * imageCount, HEIGHT_VIEWPAGER)];
    
    //if data is not a array of string,it will throw exception
    @try {
        //remove all the subview from gallery view
        for (UIView *view in self.scrollView.subviews) {
            [view removeFromSuperview];
        }
        //add view to gallery
        for (int index = 0; index < imageCount; ++index) {
            AutoLoadImageView *imgv = [[AutoLoadImageView alloc]init];
            imgv.backgroundColor = [[UserCenter shareInstance]getRandomColor];
            [imgv loadImage:imageUrls[index]];
            CGRect frame = CGRectMake(index * screenWidth, 0, screenWidth, HEIGHT_VIEWPAGER);
            
            [imgv setFrame:frame];
            //add gesture to image
            imgv.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]init];
            [tapGestureRecognizer addTarget:self action:@selector(tapped:)];
            [imgv addGestureRecognizer:tapGestureRecognizer];
            
            //set tag
            imgv.tag = TAG_BTN_OFFSET + index;
            [self.scrollView addSubview:imgv];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    times = originImageCount;
    [self clearErrorImageView];
}


-(void)clearErrorImageView{
    for (AutoLoadImageView *viewItem in self.scrollView.subviews) {
        if ([viewItem isKindOfClass:[AutoLoadImageView class]]) {
            if (viewItem.hasImageFetchFinished ) {
                if (nil == viewItem.image) {
                    //remove nil imageview
                    NSInteger index = [self.scrollView.subviews indexOfObject:viewItem];
                    //reset imageurls and image names
                    if (nil != _imageNames) {
                        NSMutableArray *names = [[NSMutableArray alloc]initWithArray:_imageNames];
                        [names removeObjectAtIndex:index];
                        _imageNames = names;
                    }
                    if (nil != _imageUrls) {
                        NSMutableArray *urls = [[NSMutableArray alloc]initWithArray:_imageUrls];
                        [urls removeObjectAtIndex:index];
                        _imageUrls = urls;
                    }
                    [viewItem removeFromSuperview];
                    //reset frame
                    NSInteger count = self.scrollView.subviews.count;
                    for (NSInteger i = index ; i < count; ++i) {
                        AutoLoadImageView *view = self.scrollView.subviews[i];
                        view.frame = CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
                        view.tag = TAG_BTN_OFFSET + i;
                    }
                    //reset content size
                    NSInteger width = [UIScreen mainScreen].bounds.size.width;
                    CGSize size = self.scrollView.contentSize;
                    size.width -= width;
                    self.scrollView.contentSize = size;
                }else{
                    --times;
                    times = times <0?0:times;
                }
                
            }
        }
    }
    
    if (times > 0) {
        [self performSelector:@selector(clearErrorImageView) withObject:nil afterDelay:0.5];
    }
    
    
}


-(void)setImageNames:(NSArray *)imageNames{
    _imageUrls = nil;
    _imageNames = imageNames;
    originImageCount = imageNames.count;
    self.currentPage = 0;
    
    NSInteger imageCount = _imageNames.count;
    CGRect appFrame = [UIScreen mainScreen].applicationFrame;
    float screenWidth = appFrame.size.width;
    //content size
    [self.scrollView setContentSize:CGSizeMake(appFrame.size.width * imageCount, HEIGHT_VIEWPAGER)];
    
    //if data is not a array of string,it will throw exception
    @try {
        //remove all the subview from gallery view
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        //add view to gallery
        for (int index = 0; index < imageCount; ++index) {
            AutoLoadImageView *imgv = [[AutoLoadImageView alloc]init];
            imgv.backgroundColor = [[UserCenter shareInstance]getRandomColor];
            NSString *fileName = imageNames[index];
            NSData *fileData = [FileManager getFileWithName:fileName type:DirectoryTypeDocument];
            UIImage *image = [UIImage imageWithData:fileData];
            imgv.image = image;
            CGRect frame = CGRectMake(index * screenWidth, 0, screenWidth, HEIGHT_VIEWPAGER);
            [imgv setFrame:frame];
            //add gesture to image
            imgv.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]init];
            [tapGestureRecognizer addTarget:self action:@selector(tapped:)];
            [imgv addGestureRecognizer:tapGestureRecognizer];
            
            //set tag
            imgv.tag = TAG_BTN_OFFSET + index;
            [self.scrollView addSubview:imgv];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

-(UIView *)viewAtIndex:(NSInteger) page{
    UIView *view = nil;
    for (UIView *viewItem in self.subviews) {
        NSInteger index = viewItem.tag - TAG_BTN_OFFSET;
        if (index == page) {
            view = viewItem;
        }
    }
    
    return view;
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(viewPagerDidScroll:)]) {
        [self.mDelegate viewPagerDidScroll:self];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.currentPage = page;
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(viewPagerDidEndDecelerating:)]) {
        [self.mDelegate viewPagerDidEndDecelerating:self];
    }
}


-(BOOL)tapped:(UIGestureRecognizer *)gestureRecognizer{
    if (hasTapActionReceived) {
        hasTapActionReceived = NO;
        return YES;
    }
    //force convert index to integer
    int index = (int) (gestureRecognizer.view.tag - TAG_BTN_OFFSET);
    
    if (self.mDelegate) {
        if ([self.mDelegate respondsToSelector:@selector(viewPagerItemDidClicked:imageName:imageUrl:)]) {
            [self.mDelegate viewPagerItemDidClicked:index imageName:_imageNames?_imageNames[index]:nil imageUrl:_imageUrls?_imageUrls[index]:nil];
        }
    }else{
        NSLog(@"please set delegate");
    }
    hasTapActionReceived = YES;
    return TRUE;
}

-(KSScrollView *)scrollView{
    KSScrollView *scrollView = nil;
    if (_scrollView == nil) {
        if (mScrollView == nil) {
            scrollView = [[KSScrollView alloc]initWithFrame:self.bounds];
            _scrollView = scrollView;
        }else{
            scrollView = mScrollView;
        }
    }else {
        scrollView = _scrollView;
    }
    scrollView.mDelegate = self;
    return scrollView;
}


-(void)setCurrentPage:(NSInteger)currentPage{
    _currentPage = currentPage;
    CGFloat width = self.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(currentPage * width, 0) animated:NO];
}

-(NSInteger)page{
    NSArray *array = nil == self.imageNames ? self.imageUrls:self.imageNames;
    return array.count;
}

-(void)ksScrollViewItemDidClicked:(KSScrollView *)scrollview{
    if (hasTapActionReceived) {
        hasTapActionReceived = NO;
        return;
    }
    int index = (int)self.currentPage;
    
    if (self.mDelegate) {
        if ([self.mDelegate respondsToSelector:@selector(viewPagerItemDidClicked:imageName:imageUrl:)]) {
            [self.mDelegate viewPagerItemDidClicked:index imageName:_imageNames?_imageNames[index]:nil imageUrl:_imageUrls?_imageUrls[index]:nil];
        }
    }else{
        NSLog(@"please set delegate");
    }
    hasTapActionReceived = YES;
}

- (void)dealloc
{
    [ViewPager cancelPreviousPerformRequestsWithTarget:self];
    self.mDelegate = nil;
}

@end

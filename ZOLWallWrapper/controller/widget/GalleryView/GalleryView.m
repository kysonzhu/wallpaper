//
//  GalleryView.m
//  Pitch
//
//  Created by zhujinhui on 14-9-1.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "GalleryView.h"
#import "AutoLoadImageView.h"
#import "UserCenter.h"

#define TAG_BTN_OFFSET 12345

@interface GalleryView ()<UIScrollViewDelegate>{
//    UIPageControl *mPageControl;
    NSTimer *timer;
}
@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,strong)UIScrollView  *mScrollView;


//@property (nonatomic, assign,readonly) NSInteger imageCount;

@end

@implementation GalleryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self resetInit];

    }
    return self;
}

-(id)init{
    if (self = [super init]) {
        [self resetInit];

    }
    return self;
}

-(UIScrollView *)mScrollView{
    if (nil == _mScrollView) {
        _mScrollView = [[UIScrollView alloc]initWithFrame:self.contentView.frame];
        [self.contentView addSubview:_mScrollView];
    }
    return _mScrollView;
}


-(void)awakeFromNib{
    [super awakeFromNib];
    [self resetInit];
}

-(void)resetInit{
//    self.showsHorizontalScrollIndicator = NO;
//    self.showsVerticalScrollIndicator = NO;
//    self.decelerationRate = 1.0;
    self.mScrollView.delegate = self;
    self.mScrollView.pagingEnabled = YES;
    [self addTimer];
//    self.directionalLockEnabled = NO;
//    self.bounces = NO;

}

/**
 * set all the image to gallery
 */
//-(void)setImageNames:(NSArray *)imageNames{
//    _imageNames = imageNames;
//    
//    NSInteger imageCount = imageNames.count;
//    CGRect appFrame = [UIScreen mainScreen].applicationFrame;
//    float screenWidth = appFrame.size.width;
//    
//    //content size
//    [self setContentSize:CGSizeMake(appFrame.size.width * imageCount, HEIGHT_GALLERY)];
//    
//    //if data is not a array of string,it will throw exception
//    @try {
//        //remove all the subview from gallery view
//        for (UIView *view in self.subviews) {
//            [view removeFromSuperview];
//        }
//        //add view to gallery
//        for (int index = 0; index < imageCount; ++index) {
//            NSString *imageName = imageNames[index];
//            UIImage *img = [UIImage imageNamed:imageName];
//            AutoLoadImageView *imgv = [[AutoLoadImageView alloc]initWithImage:img];
//            CGRect frame = CGRectMake(index * screenWidth, 0, screenWidth, HEIGHT_GALLERY);
//            [imgv setFrame:frame];
//            //add gesture to image
//            imgv.userInteractionEnabled = YES;
//            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]init];
//            [tapGestureRecognizer addTarget:self action:@selector(tapped:)];
//            [imgv addGestureRecognizer:tapGestureRecognizer];
//            
//            //set tag
//            imgv.tag = TAG_BTN_OFFSET + index;
//            [self addSubview:imgv];
//            //image control is used to show count of image
//            [self addPageControl];
//
//        }
//        
//    }
//    @catch (NSException *exception) {
//        NSLog(@"kyson exception:%@: %@",self,exception);
//    }
//}


-(NSInteger)imageCount{
    NSInteger imgCount = _imageNames.count == 0?_imageUrls.count:_imageNames.count;
    return imgCount;
}

-(void)addPageControl{
    //add page control
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.center = CGPointMake(self.frame.size.width * 0.5, self.frame.origin.y + HEIGHT_GALLERY -20);
    _pageControl.numberOfPages = self.imageCount;
    
    _pageControl.pageIndicatorTintColor = [UIColor redColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    _pageControl.enabled = NO;
    
    [self.contentView addSubview:_pageControl];
}

/**
 gallery add timer , so it can show again and again
 @see 
 */
- (void)addTimer{
   timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
       [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

/**
 go to next image , but if comes to the end ,it should return the first image
 */
-(void)nextImage{
    int page = (int)_pageControl.currentPage;
    if (page == (self.imageCount-1)) {
        page = 0;
    }else{
        page++;
    }
    CGFloat x = page * self.frame.size.width;
    [self.mScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

/**
 * set all the image to gallery
 */
-(void)setImageUrls:(NSArray *)imageUrls{
    _imageUrls = imageUrls;
    
    NSInteger imageCount = imageUrls.count;
    CGRect appFrame = [UIScreen mainScreen].applicationFrame;
    float screenWidth = appFrame.size.width;
    //content size
    [self.mScrollView setContentSize:CGSizeMake(appFrame.size.width * imageCount, HEIGHT_GALLERY)];
    
    //if data is not a array of string,it will throw exception
    @try {
        //remove all the subview from gallery view
        for (UIView *view in self.mScrollView.subviews) {
            [view removeFromSuperview];
        }
        //add view to gallery
        for (int index = 0; index < imageCount; ++index) {
            AutoLoadImageView *imgv = [[AutoLoadImageView alloc]init];
            imgv.backgroundColor = [[UserCenter shareInstance] getRandomColor];
            [imgv loadImage:imageUrls[index]];
            CGRect frame = CGRectMake(index * screenWidth, 0, screenWidth, HEIGHT_GALLERY);
            [imgv setFrame:frame];
            //add gesture to image
            imgv.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]init];
            [tapGestureRecognizer addTarget:self action:@selector(tapped:)];
            [imgv addGestureRecognizer:tapGestureRecognizer];
            
            //set tag
            imgv.tag = TAG_BTN_OFFSET + index;
            [self.mScrollView addSubview:imgv];
            
            //image control is used to show count of image
            [self addPageControl];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}


-(BOOL)tapped:(UIGestureRecognizer *)gestureRecognizer{
    //force convert index to integer
    int index = (int) (gestureRecognizer.view.tag - TAG_BTN_OFFSET);

    if (self.mDelegate) {
        if ([self.mDelegate respondsToSelector:@selector(galleryViewItemDidClicked:imageName:imageUrl:)]) {
            [self.mDelegate galleryViewItemDidClicked:index imageName:_imageNames?_imageNames[index]:nil imageUrl:_imageUrls?_imageUrls[index]:nil];
        }
    }else{
        NSLog(@"please set delegate");
    }
    return TRUE;
}



#pragma mark - scroll view delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    _pageControl.currentPage = page;
    
    //call the delegate to do something
    if ([self.mDelegate respondsToSelector:@selector(galleryViewDidScroll:)]) {
        [self.mDelegate galleryViewDidScroll:self];
    }
}


-(void)layoutSubviews{
    [super layoutSubviews];
}


- (void)dealloc
{
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        [self removeGestureRecognizer:gesture];
    }
    
    [timer invalidate];
}

@end

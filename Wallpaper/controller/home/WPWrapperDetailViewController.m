//
//  WPWrapperDetailViewController.m
//  WallWrapper ( https://github.com/kysonzhu/wallpaper.git )
//
//  Created by zhujinhui on 14-12-17.
//  Copyright (c) 2014年 zhujinhui( http://kyson.cn ). All rights reserved.
//

#import "WPWrapperDetailViewController.h"
#import "ViewPager.h"
#import "WrapperServiceMediator.h"
#import "Image.h"
#import "FileManager.h"
#import "NSString+Util.h"
#import "ImageCache.h"
#import "NSString+Util.h"
#import "FileDownload.h"
#import "Platform.h"
#import "UserCenter.h"
#import "EnvironmentConfigure.h"
#import <UIAlertView+BlocksKit.h>

#import "WPShareManager.h"
@import GoogleMobileAds;


#define TAG_BTN_LOCKSCREEN  2110
#define TAG_BTN_LAUNCH        2111
#define TAG_BTN_DOWNLOAD    2112
#define TAG_BTN_PRAISE      2114

#define TAG_IMGV_HOME        211
#define TAG_IMGV_LOCKSCREEN  212

@interface WPWrapperDetailViewController ()<ViewPagerDelegate,FileDownloadDelegate>{
    __weak IBOutlet UIView *mToolBar;
    BOOL isWidgetRevealed;
    
    __weak IBOutlet UIButton *lockButton;
    __weak IBOutlet UIButton *homeButton;
    __weak IBOutlet UIButton *downloadButton;
    __weak IBOutlet UIButton *praiseButton;
    
    BOOL hasPraised;
    
    NSMutableData *receiveData;
    FileDownload *fileDownload;

}
@property(nonatomic, strong) GADInterstitial *interstitial;

@property (nonatomic, retain) NSArray *imageList;

@property(nonatomic, weak) IBOutlet UIButton *shareButton;
@property(nonatomic, weak) IBOutlet UIButton *backButton;
@property(nonatomic, weak) IBOutlet ViewPager *mViewPager;

@end

@implementation WPWrapperDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 设置状态栏和导航栏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

#pragma mark - 状态栏隐藏

-(void)viewWillDisappear:(BOOL)animated{
    // 下面这两句顺序不能改
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}


-(void)viewDidLoad{
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view sendSubviewToBack:self.mViewPager];
    
    // 广告
    BOOL hasBuyed = [[NSUserDefaults standardUserDefaults] boolForKey:kHasBuySuccess];
    if (!hasBuyed) {
        self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-7896672979027584/3984670568"];
        GADRequest *request = [GADRequest request];
        [self.interstitial loadRequest:request];
        //延迟执行
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC); //设置时间2秒
        dispatch_after(time, dispatch_get_main_queue(), ^{
            if (self.interstitial.isReady)
                [self.interstitial presentFromRootViewController:self];
        });
    }

    self.mViewPager.mDelegate = self;
    
    //add event

    lockButton.tag = TAG_BTN_LOCKSCREEN;
    homeButton.tag = TAG_BTN_LAUNCH;
    downloadButton.tag = TAG_BTN_DOWNLOAD;
    praiseButton.tag = TAG_BTN_PRAISE;
    hasPraised = [[UserCenter shareInstance] isPraised:_group.gId];
    if (hasPraised) {
        UIImage *image = [UIImage imageNamed:@"tab_icon_collect_pre"];
        [praiseButton setBackgroundImage:image forState:UIControlStateNormal];
    }
    [lockButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [homeButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [downloadButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];

    @weakify(self);
    [[self.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [[self.shareButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [KVNProgress show];
        NSInteger page = self.mViewPager.currentPage;
        NSString *imageUrl = self.mViewPager.imageUrls[page];
        [WPShareManager shareWithURL:imageUrl type:WPShareTypePicture finished:^(BOOL success) {
            [KVNProgress dismiss];
        }];
    }];
    
    [KVNProgress show];
    NSDictionary *params = @{@"gId":self.group.gId,@"source":safeString(self.group.wallPaperSource),@"id":safeString(self.group.id)};
    WrapperServiceMediator *serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_RECOMMENDEDDETAIL params:params];
    [self doNetworkService:serviceMediator];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    //hide all widgets
    isWidgetRevealed = YES;
    [self revealWidgets:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void)revealWidgets:(BOOL)reveal{
    if (!reveal) {
        self.shareButton.hidden = YES;
        mToolBar.hidden = YES;
        isWidgetRevealed = NO;
    }else{
        self.shareButton.hidden = NO;
        mToolBar.hidden = NO;
        isWidgetRevealed = YES;
    }
}


-(void)hideLockScreenViewAndLauntchScreenView{
    //hide lock screen view or hide launtch screen view
    for (UIImageView *imgvItem in self.view.subviews)
    {
        if (imgvItem.tag == TAG_IMGV_LOCKSCREEN || imgvItem.tag == TAG_IMGV_HOME) {
            [imgvItem removeFromSuperview];
        }
    }
}

-(void)buttonClicked:(UIButton *) sender{
    [self hideLockScreenViewAndLauntchScreenView];
    switch (sender.tag) {
        case TAG_BTN_LOCKSCREEN:
        {
            if (self.mViewPager.page > 0)
            {
                CGRect frame = [UIScreen mainScreen].bounds;
                UIImageView *imgview = [[UIImageView alloc]initWithFrame:frame];
                imgview.tag = TAG_IMGV_LOCKSCREEN;
                PlatformType type = [Platform getPlatform];
                UIImage *image = nil;
                if (type == PlatformType640960) {
                    image = [UIImage imageNamed:@"lockscreen_1"];
                }else if (type == PlatformType6401136){
                    image = [UIImage imageNamed:@"lockscreen_2"];
                }else if (type == PlatformTypeiPhone6){
                    image = [UIImage imageNamed:@"lockscreen_3"];
                }else if(type == PlatformTypeiPhone6P){
                    image = [UIImage imageNamed:@"lockscreen_4"];
                }
                image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
                imgview.image = image;
                [self.view addSubview:imgview];
                [self.view bringSubviewToFront:imgview];
                [self revealWidgets:NO];
            }else{
                [KVNProgress showErrorWithStatus:@"没有图片可以预览"];
            }
        }
            break;
        case TAG_BTN_LAUNCH:
        {
            if (self.mViewPager.page > 0)
            {
                CGRect frame = [UIScreen mainScreen].bounds;
                UIImageView *imgview = [[UIImageView alloc]initWithFrame:frame];
                imgview.tag = TAG_IMGV_HOME;
                UIImage *image = nil;
                PlatformType type = [Platform getPlatform];
                if (type == PlatformType640960) {
                    image = [UIImage imageNamed:@"launtchscreen_1"];
                }else if (type == PlatformType6401136){
                    image = [UIImage imageNamed:@"launtchscreen_2"];
                }else if (type == PlatformTypeiPhone6){
                    image = [UIImage imageNamed:@"launtchscreen_3"];
                }else if(type == PlatformTypeiPhone6P){
                    image = [UIImage imageNamed:@"launtchscreen_4"];
                }
                imgview.image = image;
                [self.view addSubview:imgview];
                [self.view bringSubviewToFront:imgview];
                [self revealWidgets:NO];
            }else{
                [KVNProgress showErrorWithStatus:@"没有图片可以预览"];
            }
            
        }
            break;
        case TAG_BTN_DOWNLOAD:
        {
            if (self.mViewPager.page > 0)
            {
                NSInteger page = self.mViewPager.currentPage;
                NSString *imageUrl = self.mViewPager.imageUrls[page];
                
                //reset url to change image size
                CGRect rect = [UIScreen mainScreen].bounds;
                NSInteger width = (int) (rect.size.width * 2);
                NSInteger height = (int) (rect.size.height * 2);
                NSString *string = [NSString stringWithFormat:@"%lix%li",(long)width,(long)height];
                imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"480x854" withString:string];
                imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"320x480" withString:string];
                
                fileDownload = [[FileDownload alloc]initWithFileUrl:imageUrl];
                fileDownload.mDelegate = self;
                [fileDownload startDownload];
            }else{
                [KVNProgress showErrorWithStatus:@"没有图片可以下载"];
            }
        }
            break;
        case TAG_BTN_PRAISE:
        {
            if (self.mViewPager.page > 0)
            {
                if (!hasPraised) {
                    if (nil != _group && nil != _group.gId) {
                        [[UserCenter shareInstance] addPraiseData:_group.gId];
                        UIImage *image = [UIImage imageNamed:@"tab_icon_collect_pre"];
                        [praiseButton setBackgroundImage:image forState:UIControlStateNormal];
                        [KVNProgress showSuccessWithStatus:@"点赞成功!"];
                        hasPraised = YES;
                    }else{
                        [KVNProgress showErrorWithStatus:@"没有图片可以点赞"];
                    }
                    
                }else{
                    [KVNProgress showErrorWithStatus:@"你已经赞过"];
                }
            }else{
                [KVNProgress showErrorWithStatus:@"没有图片可以点赞"];
            }
            
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - ViewPagerDelegate
-(void)viewPagerItemDidClicked:(int)index imageName:(NSString *)imageName imageUrl:(NSString *)imageUrl{
    //hide lock screen view
    [self hideLockScreenViewAndLauntchScreenView];
    //hide all widget
    [self revealWidgets:!isWidgetRevealed];
}

-(void)viewPagerDidScroll:(ViewPager *)viewPager{
    CGFloat contentOffsetX = viewPager.scrollView.contentOffset.x;
    //if draged to the firstpage , we can pop to before
    if (contentOffsetX < -10) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewPagerDidEndDecelerating:(ViewPager *)viewPager{
    
}


-(void)refreshData:(NSString *)serviceName response:(MGNetwokResponse *)response{
    if (0 == response.errorCode) {
        [KVNProgress dismiss];
        NSDictionary *resultDict = response.rawResponseDictionary;
        if (safeString(self.group.wallPaperSource).integerValue == 2)
        {
            NSArray *imageList = resultDict[@"content"];
            Image *image = [[Image alloc] init];
            imageList = [image loadArrayPropertyWithDataSource:imageList requireModel:@"Image"];
            NSMutableArray *imgUrls = [[NSMutableArray alloc]init];
            [imgUrls addObject:self.group.coverImgUrl];
            for (Image *imageItem in imageList)
            {
                NSURL *imgURL = [NSURL URLWithString:imageItem.babyImgUrl];
                if ([imgURL.scheme isEqualToString:@"http"] || [imgURL.scheme isEqualToString:@"https"]) {
                    [imgUrls addObject:imageItem.babyImgUrl];
                }
            }
            self.mViewPager.imageUrls = imgUrls;
            self.imageList = imageList;
            return;
        }
        
        if (safeString(self.group.wallPaperSource).integerValue == 3) {
            NSArray *imageList = resultDict[@"ListContent"];
            self.mViewPager.imageUrls = imageList;
            self.imageList = imageList;
            return;
        }
        
        NSArray *imageList = resultDict[@"result"][@"imageList"];
        Image *image = [[Image alloc] init];
        imageList = [image loadArrayPropertyWithDataSource:imageList requireModel:@"Image"];
        NSMutableArray *imgUrls = [[NSMutableArray alloc]init];
        for (Image *imageItem in imageList) {
            NSURL *imgURL = [NSURL URLWithString:imageItem.imgUrl];
            if ([imgURL.scheme isEqualToString:@"http"] || [imgURL.scheme isEqualToString:@"https"]) {
                [imgUrls addObject:imageItem.imgUrl];
            }
        }
        self.mViewPager.imageUrls = imgUrls;
        self.imageList = imageList;
    }else{
        [KVNProgress showErrorWithStatus:response.errorMessage];
    }
   
}


#pragma mark - FileDownload delegate
-(void)fileDownloadDidFinish:(FileDownload *)filedownload data:(NSData *)data{
    UIImage *image = [UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
}

/**
 * image save message
 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (nil == error) {
        [KVNProgress showSuccessWithStatus:@"已保存到相册中！"];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"壁纸保存失败,请在设置中打开相册访问权限" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)fileDownloadError:(FileDownload *)filedownload error:(NSString *)error{
    //save to album
    NSInteger page = self.mViewPager.currentPage;
    NSString *imageUrl = self.mViewPager.imageUrls[page];
    NSData *data = [FileManager getFileWithName:[imageUrl md5] type:DirectoryTypeDocument];
    UIImage *image = [UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
}

-(void)dealloc{
    fileDownload.mDelegate = nil;
}

@end

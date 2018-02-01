//
//  WrapperDetailViewController.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-17.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "WrapperDetailViewController.h"
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

#define TAG_BTN_BACK        2109
#define TAG_BTN_LOCKSCREEN  2110
#define TAG_BTN_LAUNCH        2111
#define TAG_BTN_DOWNLOAD    2112
#define TAG_BTN_SHARE       2113
#define TAG_BTN_PRAISE      2114

#define TAG_IMGV_HOME        211
#define TAG_IMGV_LOCKSCREEN  212

@interface WrapperDetailViewController ()<ViewPagerDelegate,FileDownloadDelegate>{
    __weak IBOutlet ViewPager *mViewPager;
    __weak IBOutlet UIButton *backButton;
    __weak IBOutlet UIView *mToolBar;
    BOOL isWidgetRevealed;
    
    __weak IBOutlet UIButton *lockButton;
    __weak IBOutlet UIButton *homeButton;
    __weak IBOutlet UIButton *downloadButton;
    __weak IBOutlet UIButton *shareButton;
    __weak IBOutlet UIButton *praiseButton;
    
    BOOL hasPraised;
    
    NSMutableData *receiveData;
    FileDownload *fileDownload;

}

@property (nonatomic, retain) NSArray *imageList;

@end

@implementation WrapperDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
}


-(void)viewDidLoad{
    [super viewDidLoad];
    //clear all cache

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view sendSubviewToBack:mViewPager];

    mViewPager.mDelegate = self;
//    if (nil != _group && nil != _group.coverImgUrl) {
//        mViewPager.imageNames = [NSArray arrayWithObjects:[_group.coverImgUrl md5], nil];
//    }
//    mViewPager.imageUrls = [NSArray arrayWithObjects:@"http://www.baidu.com/img/bd_logo1.png",@"http://talent.baidu.com/component1000/corp/baidu/images/about/baidu.jpg",@"http://talent.baidu.com/component1000/corp/baidu/images/about/course.jpg",@"http://ww4.sinaimg.cn/bmiddle/9b7ad446jw1ekumvq1g3cj20c80m8q5g.jpg", nil];
    
    //add event
    backButton.tag = TAG_BTN_BACK;
    lockButton.tag = TAG_BTN_LOCKSCREEN;
    homeButton.tag = TAG_BTN_LAUNCH;
    downloadButton.tag = TAG_BTN_DOWNLOAD;
    shareButton.tag = TAG_BTN_SHARE;
    praiseButton.tag = TAG_BTN_PRAISE;
    hasPraised = [[UserCenter shareInstance] isPraised:_group.gId];
    if (hasPraised) {
        UIImage *image = [UIImage imageNamed:@"tab_icon_collect_pre"];
        [praiseButton setBackgroundImage:image forState:UIControlStateNormal];
    }
    [backButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [lockButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [homeButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [downloadButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [praiseButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //request
    [KVNProgress show];
    if (self.fromcontroller == FromControllerRecommended) {
        WrapperServiceMediator *serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_RECOMMENDEDDETAIL];
        ((ParamsModel *)[ParamsModel shareInstance]).gId = self.group.gId;
        [self doNetworkService:serviceMediator];
    }else if (self.fromcontroller == FromControllerLatest){
        WrapperServiceMediator *serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_RECOMMENDEDDETAIL];
        ((ParamsModel *)[ParamsModel shareInstance]).gId = self.group.gId;
        [self doNetworkService:serviceMediator];
    }else if (self.fromcontroller == FromControllerHotest){
        WrapperServiceMediator *serviceMediator = [[WrapperServiceMediator alloc]initWithName:SERVICENAME_RECOMMENDEDDETAIL];
        ((ParamsModel *)[ParamsModel shareInstance]).gId = self.group.gId;
        [self doNetworkService:serviceMediator];
    }
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
        shareButton.hidden = YES;
        [UIApplication sharedApplication].statusBarHidden = YES;
        mToolBar.hidden = YES;
        isWidgetRevealed = NO;
    }else{
        shareButton.hidden = NO;
        [UIApplication sharedApplication].statusBarHidden = NO;
        mToolBar.hidden = NO;
        isWidgetRevealed = YES;
    }
}


-(void)hideLockScreenViewAndLauntchScreenView{
    //hide lock screen view or hide launtch screen view
    for (UIImageView *imgvItem in self.view.subviews) {
        if (imgvItem.tag == TAG_IMGV_LOCKSCREEN || imgvItem.tag == TAG_IMGV_HOME) {
            [imgvItem removeFromSuperview];
        }
    }
}

-(void)buttonClicked:(UIButton *) sender{
    [self hideLockScreenViewAndLauntchScreenView];
    switch (sender.tag) {
        case TAG_BTN_BACK:{
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        case TAG_BTN_LOCKSCREEN:{
            if (mViewPager.page > 0) {
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
        case TAG_BTN_LAUNCH:{
            if (mViewPager.page > 0) {
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
        case TAG_BTN_DOWNLOAD:{
            if (mViewPager.page > 0) {
                NSInteger page = mViewPager.currentPage;
                NSString *imageUrl = mViewPager.imageUrls[page];
                
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
        case TAG_BTN_SHARE:{
            if (mViewPager.page > 0) {
                NSInteger page = mViewPager.currentPage;
                NSString *imageUrlTemp = mViewPager.imageUrls[page];
//
                NSData *data = [FileManager getFileWithName:[imageUrlTemp md5] type:DirectoryTypeDocument];
                //reset url to change image size
                CGRect rect = [UIScreen mainScreen].bounds;
                NSInteger width = (int) (rect.size.width * 2);
                NSInteger height = (int) (rect.size.height * 2);
                NSString *string = [NSString stringWithFormat:@"%lix%li",(long)width,(long)height];
                imageUrlTemp = [imageUrlTemp stringByReplacingOccurrencesOfString:@"480x854" withString:string];
                imageUrlTemp = [imageUrlTemp stringByReplacingOccurrencesOfString:@"320x480" withString:string];
//                UIImage *image = [UIImage imageWithData:data];
                
//                Image *imageModel = self.imageList[page];
//                NSString *imageUrl = [NSString stringWithFormat:@"%@/detail_%@_%@.html#p%li",HOST_PICSHOW,imageModel.gId,imageModel.pId,(long)(page+1)];
            }else{
                [KVNProgress showErrorWithStatus:@"没有图片可以分享"];
            }
            
        }
            break;
        case TAG_BTN_PRAISE:{

            if (mViewPager.page > 0) {
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


-(void)viewWillDisappear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
}

-(void)refreshData:(NSString *)serviceName response:(NetworkResponse *)response{
    if (0 == response.errorCode) {
        [KVNProgress dismiss];
        NSArray *Aryresponse = response.response;
        NSMutableArray *imgUrls = [[NSMutableArray alloc]init];
        for (Image *imageItem in Aryresponse) {
            NSURL *imgURL = [NSURL URLWithString:imageItem.imgUrl];
            if ([imgURL.scheme isEqualToString:@"http"] || [imgURL.scheme isEqualToString:@"https"]) {
                [imgUrls addObject:imageItem.imgUrl];
            }
        }
        mViewPager.imageUrls = imgUrls;
        self.imageList = Aryresponse;
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
//    [KVNProgress showErrorWithStatus:@"下载失败"];
    //save to album
    NSInteger page = mViewPager.currentPage;
    NSString *imageUrl = mViewPager.imageUrls[page];
    NSData *data = [FileManager getFileWithName:[imageUrl md5] type:DirectoryTypeDocument];
    UIImage *image = [UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
}

-(void)dealloc{
    fileDownload.mDelegate = nil;
}

@end

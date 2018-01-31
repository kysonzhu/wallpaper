//
//  MenuViewController.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-9.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "HomeViewController.h"

#import "AboutUsViewController.h"
#import "FeedbackViewController.h"
#import "KVNProgress.h"
#import "FileManager.h"
#import "EnvironmentConfigure.h"
#import "MakingGreetingCardViewController.h"

#define TAG_BTN_ABOUTUS         1287
#define TAG_BTN_FEEDBACK        1288
#define TAG_BTN_CLEARCACHE      1289
#define TAG_BTN_VALUE           1290
#define TAG_BTN_GREENINGCARD    1291

@interface MenuViewController()<UIActionSheetDelegate,UIAlertViewDelegate>{
    
    __weak IBOutlet UIButton *aboutUsButton;
    __weak IBOutlet UIButton *feedbackButton;
    __weak IBOutlet UIButton *clearCacheButton;
    __weak IBOutlet UIButton *valueButton;
    __weak IBOutlet UIButton *greetingCardButton;
    
    
}

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor redColor];
    
    aboutUsButton.tag = TAG_BTN_ABOUTUS;
    feedbackButton.tag = TAG_BTN_FEEDBACK;
    clearCacheButton.tag = TAG_BTN_CLEARCACHE;
    valueButton.tag = TAG_BTN_VALUE;
    greetingCardButton.tag = TAG_BTN_GREENINGCARD;
    
    
    [aboutUsButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [feedbackButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [clearCacheButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [valueButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [greetingCardButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [aboutUsButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)buttonClicked:(UIButton *)button{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    DDMenuController *rootViewController =  delegate.rootViewController;
    UINavigationController *navigationController = (UINavigationController *)rootViewController.rootViewController;
    [navigationController popToRootViewControllerAnimated:NO];
    switch (button.tag) {
        case TAG_BTN_ABOUTUS:{
            AboutUsViewController *aboutusViewController = [[AboutUsViewController alloc]initWithNibName:@"AboutUsViewController_iphone" bundle:nil];
            [navigationController pushViewController:aboutusViewController animated:YES];
            
        }
            break;
        case TAG_BTN_FEEDBACK:{
            FeedbackViewController *feedbackViewController = [[FeedbackViewController alloc]initWithNibName:@"FeedbackViewController_iphone" bundle:nil];
            [navigationController pushViewController:feedbackViewController animated:YES];
        }
            break;
        case TAG_BTN_CLEARCACHE:{
//            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"本地相册",@"马上拍照", nil];
//            [actionSheet showInView:self.view];
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"马上清除缓存" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"取消", nil];
            [alertView show];
        }
            break;
        case TAG_BTN_VALUE:{
            NSString *evaluateString = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=957675155"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
        }
            break;
        case TAG_BTN_GREENINGCARD:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"敬请期待!" delegate:nil cancelButtonTitle:@"知道啦" otherButtonTitles:nil, nil];
            [alert show];
//            MakingGreetingCardViewController *makingGreetingCardViewController = [[MakingGreetingCardViewController alloc]initWithNibName:@"MakingGreetingCardViewController_iphone" bundle:nil];
//            [navigationController pushViewController:makingGreetingCardViewController animated:YES];

        }
            break;
            
        default:
            break;
    }
    [rootViewController showRootController:YES];
}


#pragma mark UIActionSheetDelegate Method
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
            //Take picture
        case 0:{
            [KVNProgress show];
            [self performSelector:@selector(dismissProgress) withObject:nil afterDelay:2];
        }
            break;
            //From album
        case 1:{
            
        }
            break;
        default:
            break;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            BOOL result = [FileManager removeAllFileAtDirectory:DirectoryTypeDocument];
            if (result) {
                [KVNProgress showSuccessWithStatus:@"清除缓存成功"];
            }else{
                [KVNProgress showErrorWithStatus:@"清除缓存失败"];
            }
        }
            break;
        case 1:{
            
        }
            break;
        default:
            break;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(getCacheSize) object:nil];
    [thread start];
}

-(void)getCacheSize{
    float size = [FileManager folderSizeAtDirectionary:DirectoryTypeDocument];
    if (size > 100) {
        [FileManager removeAllFileAtDirectory:DirectoryTypeDocument];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        NSString *title = [NSString stringWithFormat:@"%dMB",(int) size ];
//        NSString *title2 = [NSString stringWithFormat:@"清除缓存(%@)",title];
        [clearCacheButton setTitle:@"清除缓存" forState:UIControlStateNormal];
    });
    
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


-(void)dismissProgress{
    [KVNProgress dismiss];
}


@end

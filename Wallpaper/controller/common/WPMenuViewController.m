//
//  WPMenuViewController.m
//  WallWrapper ( https://github.com/kysonzhu/wallpaper.git )
//
//  Created by zhujinhui on 14-12-9.
//  Copyright (c) 2014年 zhujinhui( http://kyson.cn ). All rights reserved.
//

#import "WPMenuViewController.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "WPHomeViewController.h"

#import "AboutUsViewController.h"
#import "FeedbackViewController.h"
#import "KVNProgress.h"
#import "FileManager.h"
#import "EnvironmentConfigure.h"
#import "MakingGreetingCardViewController.h"
#import "WPLessonViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

#define TAG_BTN_ABOUTUS         1287
#define TAG_BTN_FEEDBACK        1288
#define TAG_BTN_CLEARCACHE      1289

@interface WPMenuViewController()<UIActionSheetDelegate,UIAlertViewDelegate>{
    __weak IBOutlet UIButton *aboutUsButton;
    __weak IBOutlet UIButton *feedbackButton;
    __weak IBOutlet UIButton *clearCacheButton;
    __weak IBOutlet UIButton *greetingCardButton;
}

@end

@implementation WPMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    aboutUsButton.tag = TAG_BTN_ABOUTUS;
    feedbackButton.tag = TAG_BTN_FEEDBACK;
    clearCacheButton.tag = TAG_BTN_CLEARCACHE;
    
    [aboutUsButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [feedbackButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [clearCacheButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [[greetingCardButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        DDMenuController *rootViewController =  kAppDelegate.rootViewController;
        UINavigationController *navigationController = (UINavigationController *)rootViewController.rootViewController;
        WPLessonViewController *lessonViewController = [[WPLessonViewController alloc] init];
        [navigationController pushViewController:lessonViewController animated:YES];
        [rootViewController showRootController:YES];
    }];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)buttonClicked:(UIButton *)button{
    DDMenuController *rootViewController =  kAppDelegate.rootViewController;
    UINavigationController *navigationController = (UINavigationController *)rootViewController.rootViewController;
    [navigationController popToRootViewControllerAnimated:NO];
    switch (button.tag) {
        case TAG_BTN_ABOUTUS:{
            AboutUsViewController *aboutusViewController = [[AboutUsViewController alloc]init];
            [navigationController pushViewController:aboutusViewController animated:YES];
            
        }
            break;
        case TAG_BTN_FEEDBACK:{
            FeedbackViewController *feedbackViewController = [[FeedbackViewController alloc]initWithNibName:@"FeedbackViewController_iphone" bundle:nil];
            [navigationController pushViewController:feedbackViewController animated:YES];
        }
            break;
        case TAG_BTN_CLEARCACHE:{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"马上清除缓存" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"取消", nil];
            [alertView show];
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
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


-(void)dismissProgress{
    [KVNProgress dismiss];
}


@end

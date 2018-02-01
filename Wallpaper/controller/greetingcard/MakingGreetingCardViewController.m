//
//  MakingGreetingCardViewController.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 15/2/8.
//  Copyright (c) 2015年 zhujinhui. All rights reserved.
//

#import "MakingGreetingCardViewController.h"
#import "SelectBgViewController.h"

#define TAG_BTN_STARTMAKING 9870

@interface MakingGreetingCardViewController (){
    
    __weak IBOutlet UIButton *startMakingButton;
    
}

@end

@implementation MakingGreetingCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"制作贺卡";
    
    
    startMakingButton.tag = TAG_BTN_STARTMAKING;
    [startMakingButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)buttonClicked:(UIButton *) button{
    switch (button.tag) {
        case TAG_BTN_STARTMAKING:{
            SelectBgViewController *selectBgViewController = [[SelectBgViewController alloc]initWithNibName:@"SelectBgViewController_iphone" bundle:nil];
            [self.navigationController pushViewController:selectBgViewController animated:YES];
        }
            break;
            
        default:
            break;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

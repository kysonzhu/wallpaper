//
//  FeedbackViewController.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-24.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "FeedbackViewController.h"
#import "UIImage+Utils.h"

#define TAG_BTN_CONFIRM     90978
#define TAG_BTN_ADDPICTURE  90979
#define TAG_BTN_NAV_LEFT    90980


@interface FeedbackViewController ()<UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    __weak IBOutlet UITextView *feedbackTextView;
    __weak IBOutlet UITextField *emailTextField;
    
    __weak IBOutlet UIButton *confirmButton;
    __weak IBOutlet UIView *confirmBackgroundView;
    __weak IBOutlet UIButton *addPictureButton;
    
    UIImagePickerController * mPicker;
    UIButton *leftNavigationBarButton;
    
}

@end

@implementation FeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    
    feedbackTextView.textColor = [UIColor colorWithHex:0x333333 alpha:0.25];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    /**
     *  navigation bar left bar button
     */
    UIBarButtonItem *btnItem1 = [[UIBarButtonItem alloc]init];
    leftNavigationBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image1 = [UIImage imageNamed:@"nav_back"];
    [leftNavigationBarButton setBackgroundImage:image1 forState:UIControlStateNormal];
    [leftNavigationBarButton setFrame:CGRectMake(0, 0, 12, 21)];
    [leftNavigationBarButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftNavigationBarButton.tag = TAG_BTN_NAV_LEFT;
    [btnItem1 setCustomView:leftNavigationBarButton];
    self.navigationItem.leftBarButtonItem = btnItem1;
    
    feedbackTextView.delegate = self;
    emailTextField.delegate = self;
    
    confirmButton.tag = TAG_BTN_CONFIRM;
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    addPictureButton.tag = TAG_BTN_ADDPICTURE;
    [addPictureButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    confirmBackgroundView.backgroundColor = [UIColor colorWithHex:0x2b3b7a];
    
    confirmBackgroundView.layer.cornerRadius = 5.f;
}

-(void)buttonClicked:(UIButton *)button{
    switch (button.tag) {
        case TAG_BTN_CONFIRM:{
            if (nil == feedbackTextView.text || [feedbackTextView.text isEqualToString:@""] || [feedbackTextView.text hasPrefix:@"欢迎"]) {
                [KVNProgress showErrorWithStatus:@"内容不能为空"];
            }else if (nil == emailTextField.text || [emailTextField.text isEqualToString:@""] || [emailTextField.text hasPrefix:@"电话"]) {
                [KVNProgress showErrorWithStatus:@"电话或email不能为空"];
            }else{
                [KVNProgress showSuccessWithStatus:@"反馈成功!"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        case TAG_BTN_ADDPICTURE:{
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"本地相册",@"马上拍照", nil];
            [actionSheet showInView:self.view];
        }
            break;
        case TAG_BTN_NAV_LEFT:{
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark UIActionSheetDelegate Method
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    mPicker = [[UIImagePickerController alloc] init];
    mPicker.delegate = self;
    
    switch (buttonIndex) {
            //Take picture
        case 1:{
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                mPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }else{
                NSLog(@"模拟器无法打开相机");
            }
            [self presentViewController:mPicker animated:YES completion:^{}];
        }
            break;
            //From album
        case 0:{
            mPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:mPicker animated:YES completion:^{}];
        }
            break;
        default:
            break;
    }
}

#pragma
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSData *data = nil;
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *scaleImage = [originImage scaleto:0.5];
        data = UIImagePNGRepresentation(scaleImage);
        if (nil == data) {
            data = UIImageJPEGRepresentation(scaleImage, 1);
        }
        UIImage *image = [UIImage imageWithData:data];
        [addPictureButton setBackgroundImage:image forState:UIControlStateNormal];
        [self dismissViewControllerAnimated:mPicker completion:^{}];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [feedbackTextView resignFirstResponder];
    [emailTextField resignFirstResponder];
}



- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text = @"";
}


-(void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
}





@end

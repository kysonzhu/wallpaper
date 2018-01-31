//
//  OutOfNetworkView.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 15-1-14.
//  Copyright (c) 2015年 zhujinhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutOfNetworkView : UIView

+(OutOfNetworkView *)loadView;

-(void)show;


-(void)dismiss;

@end

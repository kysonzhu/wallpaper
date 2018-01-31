//
//  OutOfNetworkView.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 15-1-14.
//  Copyright (c) 2015年 zhujinhui. All rights reserved.
//

#import "OutOfNetworkView.h"

@interface OutOfNetworkView (){
    __weak IBOutlet UILabel * text1;
    __weak IBOutlet UILabel * text2;
    
}

@end


@implementation OutOfNetworkView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(OutOfNetworkView *)loadView{
    OutOfNetworkView *view = [[NSBundle mainBundle]loadNibNamed:@"OutOfNetworkView" owner:nil options:nil][0];
    view.userInteractionEnabled = NO;
    CGRect rect = view.frame;
    rect.origin.x = ([UIScreen mainScreen].bounds.size.width - rect.size.width)/2;
    rect.origin.y = ([UIScreen mainScreen].bounds.size.height - rect.size.height)/2 + 60;
    view.frame = rect;
    
    return view;
}


-(void)awakeFromNib{
    [super awakeFromNib];
    text1.textColor = [UIColor colorWithHex:0x888888];
    text2.textColor = [UIColor colorWithHex:0x888888];
}

-(void)show{
    self.hidden = NO;
}

-(void)dismiss{
    self.hidden = YES;
}




@end

//
//  KSScrollView.m
//  ZOLWallWrapper
//
//  Created by zhujinhui on 15-1-15.
//  Copyright (c) 2015年 zhujinhui. All rights reserved.
//

#import "KSScrollView.h"

@implementation KSScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)init{
    if (self = [super init]) {
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
}

-(BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view{
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(ksScrollViewItemDidClicked:)]) {
        [self.mDelegate ksScrollViewItemDidClicked:self];
    }
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}


@end

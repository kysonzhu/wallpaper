//
//  AutoLoadImageView.h
//  Pitch
//
//  Created by zhujinhui on 14-9-29.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoLoadImageView : UIImageView

@property (nonatomic,assign) BOOL hasImageFetchFinished;

-(void)loadImage:(NSString *)imageUrl;

@end

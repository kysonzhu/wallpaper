//
//  AutoLoadImageView.m
//  Pitch
//
//  Created by zhujinhui on 14-9-29.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import "AutoLoadImageView.h"
#import "ImageDownloader.h"
#import "UserCenter.h"

@interface AutoLoadImageView ()<ImageDownloaderDelegate>{
    ImageDownloader *imageDownloader;
}

@property (nonatomic, strong) UILabel *hintLabel;
@end

@implementation AutoLoadImageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)loadImage:(NSString *)imageUrl{
    self.hasImageFetchFinished = NO;
    imageDownloader = [[ImageDownloader alloc]init];
    imageDownloader.mDelegate = self;
    self.image = nil;
    self.backgroundColor = [[UserCenter shareInstance] getRandomColor];
    
    [self addSubview:self.hintLabel];
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    [imageDownloader downloadImageWithUrl:imageUrl];
}

-(void)imageDownloader:(ImageDownloader *)downloader downloadFinishedWithImage:(UIImage *)img{
    [self.hintLabel removeFromSuperview];
    self.hintLabel = nil;
    
    self.image = img;
    self.hasImageFetchFinished = YES;
}

-(void)imageDownloader:(ImageDownloader *)downloader downloadErrorWithError:(NSString *)error{
    self.hintLabel.text = @"下载失败，请重新进入后尝试";
    self.image = nil;
    self.hasImageFetchFinished = YES;
}


-(UILabel *)hintLabel{
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.font = [UIFont systemFontOfSize:12.f];
        _hintLabel.text = @"图片正在加载中...";
    }
    return _hintLabel;
}


-(void)dealloc{
    [imageDownloader cancelDownload];
    imageDownloader.mDelegate = nil;
    imageDownloader = nil;
}


@end

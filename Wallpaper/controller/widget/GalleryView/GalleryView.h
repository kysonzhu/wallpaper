//
//  GalleryView.h
//  Pitch
//
//  Created by zhujinhui on 14-9-1.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import <UIKit/UIKit.h>


#define HEIGHT_GALLERY 130

/**
 * the protocol of the gallery
 */
@protocol GalleryDelegate;

/**
 
 gallery is used to show a lot of images
 
 */


@interface GalleryView : UICollectionViewCell


@property (assign ,nonatomic) id<GalleryDelegate> mDelegate;

@property (nonatomic, retain) NSArray *imageNames;
@property (nonatomic, retain) NSArray *imageUrls;

@end

/**
 * the protocol of the gallery
 */
@protocol GalleryDelegate <NSObject>

-(void)galleryViewItemDidClicked:(int)index imageName:(NSString *)imageName imageUrl:(NSString *)imageUrl;

@optional
-(void)galleryViewDidScroll:(GalleryView *)gallery;


@end


//
//  KSCollectionViewLayout.h
//  ZOLWallWrapper
//
//  Created by zhujinhui on 14-12-24.
//  Copyright (c) 2014年 zhujinhui. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol KSCollectionViewLayoutDelegate ;

@interface KSCollectionViewLayout : UICollectionViewFlowLayout


@property (nonatomic, weak) id<KSCollectionViewLayoutDelegate> mDelegate;


-(id)initWithDelegate:(id<KSCollectionViewLayoutDelegate>) delegate;

@end


@protocol KSCollectionViewLayoutDelegate <NSObject>

-(void)kscollectionViewLayout:(KSCollectionViewLayout *)layout itemDidClicked:(NSIndexPath *) indexPath;

@end
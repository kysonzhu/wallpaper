//
//  WPRHomeViewModel.h
//  Wallpaper
//
//  Created by kyson on 2019/6/1.
//  Copyright © 2019 zhujinhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

#import "WPRBaby.h"

NS_ASSUME_NONNULL_BEGIN

@interface WPRHomeViewModel : NSObject


@property (nonatomic, strong, readonly) NSArray<WPRBaby *> *babies;
@property (nonatomic, strong, readonly) RACCommand *babiesListCommand;


@end

NS_ASSUME_NONNULL_END

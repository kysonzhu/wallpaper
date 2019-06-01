//
//  WPRPaperDetailViewModel.h
//  Wallpaper
//
//  Created by kyson on 2019/6/1.
//  Copyright © 2019 zhujinhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>



NS_ASSUME_NONNULL_BEGIN

@interface WPRPaperDetailViewModel : NSObject


@property (nonatomic, strong, readonly) RACCommand *babyDetailCommand;
@end

NS_ASSUME_NONNULL_END

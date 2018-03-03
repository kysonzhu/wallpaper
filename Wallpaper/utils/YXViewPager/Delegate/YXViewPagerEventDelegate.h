//
//  YXViewPagerEventDelegate.h
//  Pods
//
//  Created by yixiang on 17/3/29.
//
//

#import <Foundation/Foundation.h>

@protocol YXViewPagerEventDelegate <NSObject>

- (void)handleEventWithEventName:(NSString *)eventName context:(NSDictionary *)context;

@end

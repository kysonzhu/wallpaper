//
//  KSRouter.h
//  Wallpaper
//
//  Created by kyson on 02/03/2018.
//  Copyright © 2018 zhujinhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSRouter : NSObject



+(KSRouter *)shareRouter;


-(void)routeWithServiceName:(NSString *)serviceName params:(NSDictionary *)parms;


@end

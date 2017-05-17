//
//  UIApplication+HandleOpenUrl.m
//  ZBBLoginDemo
//
//  Created by 张彬彬 on 16/05/2017.
//  Copyright © 2017 binbintyou. All rights reserved.
//

#import "UIApplication+HandleOpenUrl.h"

#import "ZBBWeChatLogInManager.h"

@implementation AppDelegate (HandleOpenUrl)

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url{
    
    if ([url.absoluteString hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url
                           delegate:[ZBBWeChatLogInManager sharedManager]];

    }
    
    return NO;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(nullable NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.absoluteString hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url
                           delegate:[ZBBWeChatLogInManager sharedManager]];
        
    }
    
    return NO;
}


@end

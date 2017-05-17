//
//  ZBBAuthManager.m
//  ZBBLoginDemo
//
//  Created by 张彬彬 on 17/05/2017.
//  Copyright © 2017 binbintyou. All rights reserved.
//

#import "ZBBAuthManager.h"

#import "ZBBQQAuthManager.h"
#import "ZBBWeChatAuthManager.h"

@implementation ZBBAuthManager

+(id<ZBBAuthDelegate>)authManagerWithAuthPlatform:(ZBBAuthPlatform)platform{
    switch (platform) {
        case ZBBAuthPlatformQQ:
            return [ZBBQQAuthManager sharedManager];
            break;
        case ZBBAuthPlatformWeChat:
            return [ZBBWeChatAuthManager sharedManager];
        default:
            return nil;
            break;
    }
    
    return nil;
}

+ (BOOL)handleOpenURL:(NSURL *)url{
    if ([url.absoluteString hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:[ZBBWeChatAuthManager sharedManager]];
    }else if ([url.absoluteString hasPrefix:@"tencent"]){
        return [TencentOAuth HandleOpenURL:url];
    }
    
    return NO;
}

@end

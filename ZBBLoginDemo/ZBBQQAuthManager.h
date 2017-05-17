//
//  ZBBQQLogInManager.h
//  ZBBLoginDemo
//
//  Created by 张彬彬 on 16/05/2017.
//  Copyright © 2017 binbintyou. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZBBAuthManager.h"

#import <TencentOpenAPI/TencentOAuth.h>

@interface ZBBQQAuthManager : NSObject<ZBBAuthDelegate>

+(instancetype)sharedManager;

+ (BOOL)handleOpenURL:(NSURL *)url;

@end

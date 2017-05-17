//
//  ZBBWeChatLogInManager.h
//  ZBBLoginDemo
//
//  Created by 张彬彬 on 16/05/2017.
//  Copyright © 2017 binbintyou. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WXApi.h>

#import "ZBBAuthManager.h"

@interface ZBBWeChatAuthManager : NSObject<WXApiDelegate,ZBBAuthDelegate>

+ (instancetype) sharedManager;

@end

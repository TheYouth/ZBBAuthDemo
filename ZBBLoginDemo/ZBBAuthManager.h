//
//  ZBBAuthManager.h
//  ZBBLoginDemo
//
//  Created by 张彬彬 on 17/05/2017.
//  Copyright © 2017 binbintyou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZBBAuthPlatform) {
    ZBBAuthPlatformQQ,
    ZBBAuthPlatformWeChat
};

@protocol ZBBLogInDelegate <NSObject>

// 登入认证成功
- (void) logInSuccessed;
- (void) logInSuccessedWithUserInfo:(NSDictionary*)userInfo;

// 登入认证失败
- (void) logInFailed;
- (void) logInFailedWithError:(NSError*)error;

@end

@protocol ZBBLogOutDelegate <NSObject>

// 登出成功
- (void) logOutSuccessed;

// 登出失败
- (void) logOutFailed;

@end

@protocol ZBBAuthDelegate

@property (nonatomic, weak) id<ZBBLogInDelegate,ZBBLogOutDelegate> delegate;

@required
// 登入登出接口，以后扩展成可传参
- (void) logIn;
- (void) logOut;

@end

@interface ZBBAuthManager : NSObject

+ (id<ZBBAuthDelegate>) authManagerWithAuthPlatform:(ZBBAuthPlatform)platform;

+ (BOOL)handleOpenURL:(NSURL *)url;

@end

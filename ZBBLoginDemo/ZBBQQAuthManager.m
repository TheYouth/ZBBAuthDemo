//
//  ZBBQQLogInManager.m
//  ZBBLoginDemo
//
//  Created by 张彬彬 on 16/05/2017.
//  Copyright © 2017 binbintyou. All rights reserved.
//

#import "ZBBQQAuthManager.h"

static NSString* kAppID = @"222222";
static NSString* kTokenKey = @"token";
static NSString* kOpenIDKey = @"openID";
static NSString* kExpirationDateKey = @"expirationDate";
static NSString* kUnionID = @"unionID";

@interface ZBBQQAuthManager ()<TencentSessionDelegate>

@end

@implementation ZBBQQAuthManager{
    TencentOAuth* _oauth;
    NSMutableDictionary* _resultDic; // 保存返回的用户信息和unionid,两者异步
}
@synthesize delegate = _delegate;

#pragma mark - ♻️life cycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static ZBBQQAuthManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[ZBBQQAuthManager alloc] init];
    });
    return instance;
}

+ (BOOL)handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url];
}

-(instancetype)init{
    if (self = [super init]) {
        //向qq注册
        _oauth = [[TencentOAuth alloc]initWithAppId:kAppID
                                        andDelegate:self];
        _resultDic = [[NSMutableDictionary alloc]init];
    }
    
    return self;
}

#pragma mark - 🍐delegate
// TencentLoginDelegate

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin{
    NSLog(@"tencentDidLogin");
    
    [_oauth getUserInfo];
    [_oauth RequestUnionId];
    
    // token有效期一个月
    NSString* token = _oauth.accessToken;
    NSString* openID = _oauth.openId;
    NSDate* expirationDate = _oauth.expirationDate;
    
    // TODO : 安全考虑，最好放到服务器或用keychain保存
    [[NSUserDefaults standardUserDefaults]setObject:token forKey:kTokenKey];
    [[NSUserDefaults standardUserDefaults]setObject:openID forKey:kOpenIDKey];
    [[NSUserDefaults standardUserDefaults]setObject:expirationDate forKey:kExpirationDateKey];
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{
    NSLog(@"tencentDidNotLogin");
    NSError* error = [NSError errorWithDomain:@"用户退出登录"
                                         code:1001
                                     userInfo:nil];
    
    [self delegateResponseLogInFailedWithError:error];
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
    NSLog(@"tencentDidNotNetWork");
    NSError* error = [NSError errorWithDomain:@"网络问题"
                                         code:1002
                                     userInfo:nil];
    
    [self delegateResponseLogInFailedWithError:error];
}

/**
 * 获取用户个人信息回调
 */
- (void)getUserInfoResponse:(APIResponse*) response{
    NSLog(@"response = %@",response);
    if (response.retCode != URLREQUEST_SUCCEED) {
        NSError* error = [NSError errorWithDomain:@"用户信息取得失败"
                                             code:1003
                                         userInfo:nil];
        
        [self delegateResponseLogInFailedWithError:error];
        return;
    }
    
    // userInfo 和 unionID同时取到了返回
    @synchronized (self) {
        if (_resultDic.count > 0) {
            [_resultDic setDictionary:response.jsonResponse];
            
            if (self.delegate &&
                [self.delegate respondsToSelector:@selector(logInSuccessed)]) {
                [self.delegate logInSuccessed];
            }
            if (self.delegate &&
                [self.delegate respondsToSelector:@selector(logInSuccessedWithUserInfo:)]) {
                [self.delegate logInSuccessedWithUserInfo:[_resultDic copy]];
            }
        }else{
            [_resultDic setDictionary:response.jsonResponse];
        }
    }
}

/**
 * unionID获得
 */
- (void)didGetUnionID{
    NSLog(@"uniodId = %@",_oauth.unionid);
    
    NSString* unionID = _oauth.unionid;
    if (unionID && unionID.length > 0) {
        @synchronized (self) {
            if (_resultDic.count > 0) {
                [_resultDic setObject:unionID forKey:kUnionID];
                
                if (self.delegate &&
                    [self.delegate respondsToSelector:@selector(logInSuccessed)]) {
                    [self.delegate logInSuccessed];
                }
                if (self.delegate &&
                    [self.delegate respondsToSelector:@selector(logInSuccessedWithUserInfo:)]) {
                    [self.delegate logInSuccessedWithUserInfo:[_resultDic copy]];
                }
            }else{
                [_resultDic setObject:unionID forKey:kUnionID];
            }
        }
    }else{
        NSError* error = [NSError errorWithDomain:@"unionID取得失败"
                                             code:1004
                                         userInfo:nil];
        
        [self delegateResponseLogInFailedWithError:error];
    }
}
#pragma mark - 🔒private

-(void)clearAuthorizeInfo{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kTokenKey];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kOpenIDKey];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kExpirationDateKey];
}

// 通过token取得userInfo
-(BOOL)logInWithToken:(NSString*)token openID:(NSString*)openID expirationDate:(NSDate*)expirationDate{
    if (token && token.length > 0) {
        _oauth.accessToken = token;
        _oauth.openId = openID;
        _oauth.expirationDate = expirationDate;
    }
    
    if ([_oauth getUserInfo] &&
        [_oauth RequestUnionId]) {
        return YES;
    }
    
    return NO;
}

// 登入授权
-(void)qqAuthorize{
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            nil];
    
    [_oauth authorize:permissions inSafari:NO];
}

-(void)delegateResponseLogInFailedWithError:(NSError*)error{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(logInFailed)]) {
        [self.delegate logInFailed];
    }
    
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(logInFailedWithError:)]) {
        [self.delegate logInFailedWithError:error];
    }
}

#pragma mark - 🔄overwrite

#pragma mark - 🚪public
-(void)logIn{
    
    NSString* token = [[NSUserDefaults standardUserDefaults]objectForKey:kTokenKey];
    NSString* openID = [[NSUserDefaults standardUserDefaults]objectForKey:kOpenIDKey];
    NSDate* expirationDate = [[NSUserDefaults standardUserDefaults]objectForKey:kExpirationDateKey];
    
    // 如果token未实效，就不用再登入qq授权
    if ([self logInWithToken:token
                      openID:openID
              expirationDate:expirationDate]) {
        return;
    }
    
    [self qqAuthorize];
}

-(void)logOut{
    [_oauth logout:self];
    
    // 清理token
    [self clearAuthorizeInfo];
    
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(logOutSuccessed)]) {
        [self.delegate logOutSuccessed];
    }
}

#pragma mark - ☸getter and setter


@end

//
//  ZBBWeChatLogInManager.m
//  ZBBLoginDemo
//
//  Created by 张彬彬 on 16/05/2017.
//  Copyright © 2017 binbintyou. All rights reserved.
//

#import "ZBBWeChatAuthManager.h"

static NSString *kWXAppID = @"wxd930ea5d5a258f4f";
static NSString *kAuthScope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
static NSString *kAuthOpenID = @"0c806938e2413ce73eef92cc3";
static NSString *kAuthState = @"xxx";

@interface ZBBWeChatAuthManager ()<WXApiDelegate>

@end

@implementation ZBBWeChatAuthManager
@synthesize delegate = _delegate;

#pragma mark - ♻️life cycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static ZBBWeChatAuthManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[ZBBWeChatAuthManager alloc] init];
    });
    return instance;
}

-(instancetype)init{
    if (self = [super init]) {
        //向微信注册
        [WXApi registerApp:kWXAppID enableMTA:YES];
    }
    
    return self;
}

#pragma mark - 🔒private

#pragma mark - 🔄overwrite

#pragma mark - 🚪public

-(void)logIn{
    
    // step 1:取得code
    
    SendAuthReq* authReq = [[SendAuthReq alloc]init];
    // 应用授权作用域
    authReq.scope = kAuthScope;
    // 该参数可用于防止csrf攻击
    authReq.state = kAuthState;
    // 应用唯一标识，在微信开放平台提交应用审核通过后获得
    authReq.openID = kAuthOpenID;
    
    // 发送认证请求
    [WXApi sendAuthReq:authReq
        viewController:nil
              delegate:nil];
}

-(void)logOut{
    //  TODO
}

#pragma mark - 🍐delegate
// 
-(void) onResp:(BaseResp*)resp{
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResp = (SendAuthResp *)resp;
        
        // errcode为0时，取得code，用来获取access_token
        NSLog(@"授权信息取得:code=%@,state=%@,errcode=%d",authResp.code,authResp.state,authResp.errCode);
        
        // step 2:通过code获取access_token
        
        // step 3:通过access_token调用接口
        // 接口文档：https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419317853&lang=zh_CN
    }
}
#pragma mark - ☸getter and setter

@end

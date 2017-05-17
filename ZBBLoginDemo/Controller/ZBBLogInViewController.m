//
//  ZBBLogInViewController.m
//  ZBBLoginDemo
//
//  Created by 张彬彬 on 15/05/2017.
//  Copyright © 2017 binbintyou. All rights reserved.
//

#import "ZBBLogInViewController.h"

#import "ZBBLogInView.h"

@interface ZBBLogInViewController ()

@end

@implementation ZBBLogInViewController

#pragma mark - ♻️life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ZBBLogInView* logInView = [[ZBBLogInView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:logInView];
}

#pragma mark - 🔒private

#pragma mark - 🔄overwrite

#pragma mark - 🚪public

#pragma mark - 🍐delegate

#pragma mark - ☎️notification

#pragma mark - 🎬event response

#pragma mark - ☸getter and setter

@end

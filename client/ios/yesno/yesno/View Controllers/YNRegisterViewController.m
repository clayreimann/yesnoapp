//
//  YNRegisterViewController.m
//  yesno
//
//  Created by Clay Reimann on 8/25/14.
//  Copyright (c) 2014 Sudo Studios. All rights reserved.
//

#import "YNRegisterViewController.h"

#import "YNUser.h"
#import "YNQuestionAPI.h"

@implementation YNRegisterViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[YNQuestionAPI questionAPI] registerForPushNotifications];
}

- (void)registerEmail:(id)sender {
    YNQuestionAPI *questionMaster = [YNQuestionAPI questionAPI];
    YNUser *user;
    
    user = [YNUser new];
    user.name = @"Foo";
    user.email = self.emailField.text;
    
    [questionMaster registerUser:user];
}

@end

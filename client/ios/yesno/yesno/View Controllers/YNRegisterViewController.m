//
//  YNRegisterViewController.m
//  yesno
//
//  Created by Clay Reimann on 8/25/14.
//  Copyright (c) 2014 Sudo Studios. All rights reserved.
//

#import "YNRegisterViewController.h"

#import "YNUser.h"
#import "YNQuestionMaster.h"

@implementation YNRegisterViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[YNQuestionMaster questionMaster] registerForPushNotifications];
}

- (void)registerEmail:(id)sender {
    YNQuestionMaster *questionMaster = [YNQuestionMaster questionMaster];
    YNUser *user;
    
    user = [YNUser new];
    user.name = @"Foo";
    user.email = self.emailField.text;
    
    [questionMaster registerUser:user];
}

@end

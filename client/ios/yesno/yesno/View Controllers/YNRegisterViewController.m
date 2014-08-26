//
//  YNRegisterViewController.m
//  yesno
//
//  Created by Clay Reimann on 8/25/14.
//  Copyright (c) 2014 Sudo Studios. All rights reserved.
//

#import "YNRegisterViewController.h"

#import "FSNConnection.h"

@implementation YNRegisterViewController

NSString *BaseAPIPath = @"http://clank.sudostudios.com/yes";

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)registerEmail:(id)sender {
    NSURL *url = [NSURL URLWithString:[BaseAPIPath stringByAppendingString:@"/register"]];
    NSDictionary *params = @{
        @"email": self.emailField.text,
        @"apnID": [[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"] description]
    };
    
    FSNConnection *c = [FSNConnection withUrl:url method:FSNRequestMethodPOST headers:nil parameters:params parseBlock:^id(FSNConnection *conn, NSError **e) {
        return [NSJSONSerialization JSONObjectWithData:conn.responseData options:0 error:e];

    } completionBlock:^(FSNConnection *conn) {
        NSLog(@"%@", conn.parseResult);
    } progressBlock:nil];
    
    [c start];
}

@end

//
//  YNQuestionMaster.m
//  yesno
//
//  Created by Clay Reimann on 8/26/14.
//  Copyright (c) 2014 Sudo Studios. All rights reserved.
//

#import "YNQuestionAPI.h"

#import <UIKit/UIKit.h>

#import "YNUser.h"
#import "FSNConnection.h"

@implementation YNQuestionAPI

static NSString const *BaseAPIPath = @"http://clank.sudostudios.com/yes";

+ (YNQuestionAPI *)questionAPI {
    static YNQuestionAPI *master = nil;
    
    if(master == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            master = [YNQuestionAPI new];
        });
    }
    
    return master;
}

- (void)registerForPushNotifications {
    NSSet *categories;
    UIUserNotificationType types;
    UIUserNotificationSettings *settings;
    UIMutableUserNotificationCategory *category;
    UIMutableUserNotificationAction *yes, *no;
    
    yes = [UIMutableUserNotificationAction new];
    yes.title = @"Yes";
    yes.identifier = @"yes";
    yes.destructive = NO;
    yes.authenticationRequired = NO;
    yes.activationMode = UIUserNotificationActivationModeBackground;
    
    no = [UIMutableUserNotificationAction new];
    no.title = @"No";
    no.identifier = @"no";
    no.destructive = YES;
    no.authenticationRequired = NO;
    no.activationMode = UIUserNotificationActivationModeBackground;
    
    category = [[UIMutableUserNotificationCategory alloc] init];
    category.identifier = @"question";
    [category setActions:@[no, yes] forContext:UIUserNotificationActionContextDefault];
    
    categories = [NSSet setWithObject:category];
    types = UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound;
    settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)registerUser:(YNUser *)user {
    NSURL *url = [NSURL URLWithString:[BaseAPIPath stringByAppendingString:@"/register"]];
    NSDictionary *params = @{
                             @"email": user.email,
                             @"apnID": [[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"] description]
                             };
    
    FSNConnection *c = [FSNConnection withUrl:url method:FSNRequestMethodPOST
                                      headers:nil parameters:params parseBlock:^id(FSNConnection *conn, NSError **e)
    {
        return [NSJSONSerialization JSONObjectWithData:conn.responseData options:0 error:e];
        
    }
                              completionBlock:^(FSNConnection *conn)
    {
        NSString *message;
        NSDictionary *result;
        
        NSLog(@"data: %@\nresult: %@\nerror: %@", [conn.responseData stringFromUTF8], conn.parseResult, conn.error);
        
        message = @"Failed to register your device";
        if(conn.parseResult != nil) {
            result = (NSDictionary *)conn.parseResult;
            
            if(result[@"success"]) {
                message =[NSString stringWithFormat:@"Successfully registered your device as user: %@", result[@"userID"]];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:@"Register device"
                                        message:message
                                       delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil] show];
        });
    } progressBlock:nil];
    
    [c start];

}

- (void)addUserAsFriend:(YNUser *)user {
    NSURL *url = [NSURL URLWithString:[BaseAPIPath stringByAppendingString:@"/lookup"]];
    NSDictionary *params = @{
                             @"email": user.email
                             };
    
    FSNConnection *c = [FSNConnection withUrl:url method:FSNRequestMethodGET headers:nil parameters:params
                                   parseBlock:^id(FSNConnection *conn, NSError **e)
    {
        return [NSJSONSerialization JSONObjectWithData:conn.responseData options:0 error:e];
    } completionBlock:^(FSNConnection *conn)
    {
        NSDictionary *result;
        NSNumber *userID;
        
        if([conn.parseResult isKindOfClass:[NSDictionary class]]) {
            result = (NSDictionary *)conn.parseResult;
            if(result[@"success"]) {
                // add friend
                userID = result[@"respondent"];
            }
        } else {
            // server error
        }
    } progressBlock:nil];
    
    [c start];
}

@end

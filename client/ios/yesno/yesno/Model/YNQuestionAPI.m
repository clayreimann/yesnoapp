//
//  YNQuestionMaster.m
//  yesno
//
//  Created by Clay Reimann on 8/26/14.
//  Copyright (c) 2014 Sudo Studios. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "FSNConnection.h"

#import "YNQuestionAPI.h"

#import "StringConstants.h"
#import "YNUser.h"
#import "YNQuestionDataSource.h"

@interface FSNConnection (APIMethods)

+ (FSNConnection *)apiEndpoint:(NSString *)endpoint withParameters:(NSDictionary *)parameters completion:(FSNCompletionBlock)block;

@end

@implementation FSNConnection (APIMethods)

static NSString const *BaseAPIPath = @"http://clank.sudostudios.com/yes";

+ (FSNConnection *)apiEndpoint:(NSString *)endpoint withParameters:(NSDictionary *)parameters completion:(FSNCompletionBlock)block {
    NSURL *url;
    FSNRequestMethod method;
    
    if([endpoint isEqualToString:@"/lookup"]) {
        method = FSNRequestMethodGET;
    } else {
        method = FSNRequestMethodPOST;
    }
    
    url = [NSURL URLWithString:[BaseAPIPath stringByAppendingString:endpoint]];
    FSNConnection *connection = [FSNConnection
                                 withUrl:url
                                 method:method
                                 headers:nil
                                 parameters:parameters
                                 parseBlock:^id(FSNConnection *c, NSError ** e) { return [NSJSONSerialization JSONObjectWithData:c.responseData options:0 error:e]; }
                                 completionBlock:block
                                 progressBlock:nil];
    
    return connection;
}

@end

@implementation YNQuestionAPI

/**
 *  Get the singleton api instance
 *
 *  @return the singleton
 */
+ (YNQuestionAPI *)api {
    static YNQuestionAPI *master = nil;
    
    if(master == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            master = [YNQuestionAPI new];
        });
    }
    
    return master;
}

/**
 *  Encapsulate the process of asking for permission to push to the user
 */
- (void)registerForPushNotifications {
    NSSet *categories;
    UIUserNotificationType types;
    UIUserNotificationSettings *settings;
    UIMutableUserNotificationCategory *category;
    UIMutableUserNotificationAction *yes, *no;
    
    yes                        = [UIMutableUserNotificationAction new];
    yes.title                  = @"Yes";
    yes.identifier             = kYNPushActionYes;
    yes.destructive            = NO;
    yes.authenticationRequired = NO;
    yes.activationMode         = UIUserNotificationActivationModeBackground;
    
    no                        = [UIMutableUserNotificationAction new];
    no.title                  = @"No";
    no.identifier             = kYNPushActionNo;
    no.destructive            = YES;
    no.authenticationRequired = NO;
    no.activationMode         = UIUserNotificationActivationModeBackground;
    
    category = [[UIMutableUserNotificationCategory alloc] init];
    category.identifier = @"question";
    [category setActions:@[no, yes] forContext:UIUserNotificationActionContextDefault];
    
    categories = [NSSet setWithObject:category];
    types = UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound;
    settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

/**
 *  This talks to the server to register our push key with our email address
 *
 *  @param user       an object representing our current user
 *  @param completion a block that returns a dictionary object containing either {success: NSString} or {error: NSError}
 */
- (void)registerUser:(YNUser *)user completion:(APICompletion)completion {
    NSDictionary *params = @{ @"email": user.email,
                              @"apnID": [[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"] description] };
    
    FSNConnection *connection = [FSNConnection apiEndpoint:@"/register" withParameters:params completion:^(FSNConnection *c) {
        NSString *message;
        NSDictionary *result;
        
        NSLog(@"data: %@\nresult: %@\nerror: %@", [c.responseData stringFromUTF8], c.parseResult, c.error);
        
        message = @"Failed to register your device";
        if([c.parseResult isKindOfClass:[NSDictionary class]]) {
            result = (NSDictionary *)c.parseResult;
            
            if(result[@"success"]) {
                message =[NSString stringWithFormat:@"Successfully registered your device as user: %@", result[@"userID"]];
            }
        } else {
            result = @{@"error": c.error};
        }
        
        completion(result);

    }];
    
    [connection start];

}

/**
 *  Talks to the server to see if the user provided is registered with the system
 *
 *  @param user       a user to look up
 *  @param completion a block that returns a dictionary object containing either {success: NSString} or {error: NSError}
 */
- (void)addUserAsFriend:(YNUser *)user completion:(APICompletion)completion{
    NSDictionary *params = @{ @"email": user.email };
    
    FSNConnection *connection = [FSNConnection apiEndpoint:@"/lookup" withParameters:params completion:^(FSNConnection *c) {
        NSDictionary *result;
        NSNumber *userID;
        
        if([c.parseResult isKindOfClass:[NSDictionary class]]) {
            result = (NSDictionary *)c.parseResult;
            if(result[@"success"]) {
                userID = result[@"respondent"];
                user.userID = userID;
                [[YNQuestionDataSource source] addUser:user];
            }
        } else {
            result = @{@"error": c.error};
        }
        
        completion(result);
        
    }];
    
    [connection start];
}

/**
 *  Talks to the server to ask a question
 *
 *  @param question   the question that should be asked
 *  @param completion a block that returns a dictionary object containing either {success: NSString} or {error: NSError}
 */
- (void)askQuestion:(YNQuestion *)question completion:(APICompletion)completion {
    
}

@end

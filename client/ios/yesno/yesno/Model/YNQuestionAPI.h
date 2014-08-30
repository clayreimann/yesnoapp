//
//  YNQuestionMaster.h
//  yesno
//
//  Created by Clay Reimann on 8/26/14.
//  Copyright (c) 2014 Sudo Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^APICompletion)(NSDictionary *json);

@class YNUser;
@class YNQuestion;
@interface YNQuestionAPI : NSObject

+ (YNQuestionAPI *)api;

- (void)registerForPushNotifications;

- (void)registerUser:(YNUser *)user completion:(APICompletion)completion;
- (void)addUserAsFriend:(YNUser *)user completion:(APICompletion)completion;
- (void)askQuestion:(YNQuestion *)question completion:(APICompletion)completion;

@end
//
//  YNQuestionMaster.h
//  yesno
//
//  Created by Clay Reimann on 8/26/14.
//  Copyright (c) 2014 Sudo Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YNUser;
@class YNQuestion;
@interface YNQuestionMaster : NSObject

+ (YNQuestionMaster *)questionMaster;

- (void)registerForPushNotifications;

- (void)registerUser:(YNUser *)user;
- (void)askQuestion:(YNQuestion *)question;

@end

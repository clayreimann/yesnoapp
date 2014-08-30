//
//  YNQuestion.m
//  yesno
//
//  Created by Clay Reimann on 8/29/14.
//  Copyright (c) 2014 Sudo Studios. All rights reserved.
//

#import "YNQuestion.h"

#import "StringConstants.h"

@implementation YNQuestion

/**
 *  Did the user answer the question
 *
 *  @return `YES` or `NO` depending on if the user has answered the question
 */
- (BOOL)didAnswerQuestion {
    return self.response != nil;
}

/**
 *  How did the user respond to the question
 *
 *  @return `YES` or `NO` as the user answered
 */
- (BOOL)responseToQuestion {
    return [self.response isEqualToString:kYNPushActionYes];
}

@end

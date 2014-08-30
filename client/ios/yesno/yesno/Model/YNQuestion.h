//
//  YNQuestion.h
//  yesno
//
//  Created by Clay Reimann on 8/29/14.
//  Copyright (c) 2014 Sudo Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YNQuestion : NSObject


@property (nonatomic) NSNumber *fromUser;
@property (nonatomic) NSNumber *toUser;
@property (nonatomic) NSString *interrogative;
@property (nonatomic) NSString *response;

@property (nonatomic, readonly) BOOL didAnswerQuestion;
@property (nonatomic, readonly) BOOL responseToQuestion;

@end

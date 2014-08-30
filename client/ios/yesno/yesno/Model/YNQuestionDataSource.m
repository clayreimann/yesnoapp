//
//  YNQuestionDataSource.m
//  yesno
//
//  Created by Clay Reimann on 8/29/14.
//  Copyright (c) 2014 Sudo Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YNQuestionDataSource.h"

#import "YNUser.h"
#import "YNQuestion.h"

@interface YNQuestionDataSource ()

- (void)loadUsers;
- (void)loadQuestions;

@end

@implementation YNQuestionDataSource

static NSMutableArray *users = nil;
static NSMutableDictionary *questions = nil;

#pragma mark - Initialization / Singleton methods
+ (YNQuestionDataSource *)source {
    static YNQuestionDataSource *shared = nil;
    if(shared == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shared = [[YNQuestionDataSource alloc] init];
        });
    }
    
    return shared;
}

- (id)init {
    self = [super init];
    
    if(self) {
        [self loadUsers];
        [self loadQuestions];
    }
    
    return self;
}

- (void)loadUsers {
    users = [NSMutableArray new];
}

- (void)loadQuestions {
    questions = [NSMutableDictionary new];
}


#pragma mark - Interface methods
//TODO: Move these to a protocol

- (void)addUser:(YNUser *)user {
    [users addObject:user];
}

- (void)receivedQuestion:(NSDictionary *)pushNotification withAction:(NSString *)acceptance {
    YNQuestion *question = [YNQuestion new];
    question.interrogative = pushNotification[@"aps"][@"alert"];

    questions[pushNotification[@"interrogator"]] = pushNotification[@"aps"][@"alert"];
}

- (NSInteger)numberOfUserRows {
    return users.count;
}

- (NSInteger)numberOfQuestionSections {
    return questions.count;
}

- (NSInteger)numberOfQuestionRowsInSection:(NSInteger)section {
    return [questions[@(section)] count];
}

- (YNUser *)userForRowAtIndexPath:(NSIndexPath *)indexPath {
    return users[indexPath.row];
}

- (YNQuestion *)questionForRowAtIndexPath:(NSIndexPath *)indexPath {
    YNUser *user = users[indexPath.row];
    return questions[user.userID][indexPath.row];
}

@end

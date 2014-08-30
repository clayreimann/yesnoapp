//
//  YNQuestionDataSource.m
//  yesno
//
//  Created by Clay Reimann on 8/29/14.
//  Copyright (c) 2014 Sudo Studios. All rights reserved.
//

#import "YNQuestionDataSource.h"

@interface YNQuestionDataSource ()

- (void)loadUsers;
- (void)loadQuestions;

@end

@implementation YNQuestionDataSource

static NSMutableArray *users = nil;
static NSMutableDictionary *questions = nil;


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

- (void)recievedQuestion:(NSDictionary *)pushNotification withAction:(BOOL)acceptance {
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
    return nil;
}

- (YNQuestion *)questionForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end

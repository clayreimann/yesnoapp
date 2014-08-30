//
//  YNQuestionDataSource.h
//  yesno
//
//  Created by Clay Reimann on 8/29/14.
//  Copyright (c) 2014 Sudo Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YNUser;
@class YNQuestion;
@interface YNQuestionDataSource : NSObject

+ (YNQuestionDataSource *)source;

- (void)recievedQuestion:(NSDictionary *)pushNotification withAction:(BOOL)acceptance;

- (NSInteger)numberOfUserRows;
- (NSInteger)numberOfQuestionSections;
- (NSInteger)numberOfQuestionRowsInSection:(NSInteger)section;

- (YNUser *)userForRowAtIndexPath:(NSIndexPath *)indexPath;
- (YNQuestion *)questionForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

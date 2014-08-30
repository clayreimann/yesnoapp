//
//  YNQuestion.h
//  yesno
//
//  Created by Clay Reimann on 8/29/14.
//  Copyright (c) 2014 Sudo Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YNQuestion : NSObject

@property (nonatomic) NSInteger fromUser;
@property (nonatomic) NSInteger toUser;
@property (nonatomic) NSString *interrogative;
@property (nonatomic) BOOL answer;

@end

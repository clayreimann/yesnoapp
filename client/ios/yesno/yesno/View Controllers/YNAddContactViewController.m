//
//  YNAddContactViewController.m
//  yesno
//
//  Created by Clay Reimann on 8/29/14.
//  Copyright (c) 2014 Sudo Studios. All rights reserved.
//

#import "YNAddContactViewController.h"

#import "StringConstants.h"
#import "YNUser.h"
#import "YNQuestionAPI.h"

@interface YNAddContactViewController () <UIAlertViewDelegate> {
    BOOL _shouldDismiss;
    UIBarButtonItem *_addButton;
}

@end

@implementation YNAddContactViewController

- (void)addContact:(id)sender {
    YNUser *user = [YNUser new];
    UIActivityIndicatorView *spinner;
    
    user.name = self.name.text;
    user.email = self.email.text;
    
    _addButton = self.navigationItem.rightBarButtonItem;
    spinner = [[UIActivityIndicatorView alloc] init];
    spinner.color = [UIColor blueColor];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    [[YNQuestionAPI api] addUserAsFriend:user completion:^(NSDictionary *json) {
        NSString *message;
        
        if(json[@"success"] != nil) {
            message = @"Added friend successfully";
            _shouldDismiss = YES;
        } else {
            message = @"Sorry, we can't find that person.";
        }
        
        [[[UIAlertView alloc] initWithTitle:@"Add Friend" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"clicked");
    self.navigationItem.rightBarButtonItem = _addButton;
    _addButton = nil;
    
    if(_shouldDismiss) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kYNAddedFriendNotification object:self];
    }
}

@end

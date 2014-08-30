//
//  YNContactListViewController.m
//  yesno
//
//  Created by Clay Reimann on 8/29/14.
//  Copyright (c) 2014 Sudo Studios. All rights reserved.
//

#import "YNContactListViewController.h"

#import "StringConstants.h"
#import "YNQuestionAPI.h"
#import "YNQuestionDataSource.h"
#import "YNUser.h"
#import "YNQuestion.h"

@interface YNContactListViewController () {
    YNQuestionDataSource *_source;
    NSMutableArray *_respondents;
}

- (void)didAddFriend:(NSNotification *)notificaiton;

@end

@implementation YNContactListViewController


#pragma mark - Navigation

- (void)viewDidLoad {
    _source = [YNQuestionDataSource source];
    _respondents = [NSMutableArray new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddFriend:) name:kYNAddedFriendNotification object:nil];
}

#pragma mark - UITableViewController methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_source numberOfUserRows];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YNUser *user;
    UITableViewCell *cell;
    
    user = [_source userForRowAtIndexPath:indexPath];
    cell = [tableView dequeueReusableCellWithIdentifier:@"friend" forIndexPath:indexPath];
    cell.textLabel.text = user.name;
    cell.detailTextLabel.text = user.email;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YNUser *user = [_source userForRowAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [_respondents addObject:user];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [_respondents removeObject:user];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Custom methods
- (void)didAddFriend:(NSNotification *)notificaiton {
    [self.navigationController popViewControllerAnimated:YES];
    [self.tableView reloadData];
}

- (void)askQuestion:(id)sender {
    YNUser *user = [_respondents firstObject];
    YNQuestion *question = [YNQuestion new];
    question.interrogative = [self.questionText.text stringByAppendingString:@"?"];
    question.toUser = user.userID;
    question.fromUser = @(1);
    
    [[YNQuestionAPI api] askQuestion:question completion:^(NSDictionary *json) {
        if(json[@"error"] != nil) {
            [[[UIAlertView alloc] initWithTitle:@"Ask question" message:@"Couldn't ask that question" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        } else {
            self.questionText.text = @"";
        }
    }];
}

@end

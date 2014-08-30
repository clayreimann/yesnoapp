//
//  YNContactListViewController.m
//  yesno
//
//  Created by Clay Reimann on 8/29/14.
//  Copyright (c) 2014 Sudo Studios. All rights reserved.
//

#import "YNContactListViewController.h"

#import "StringConstants.h"
#import "YNQuestionDataSource.h"

@interface YNContactListViewController () {
    YNQuestionDataSource *_source;
}

- (void)didAddFriend:(NSNotification *)notificaiton;

@end

@implementation YNContactListViewController


#pragma mark - Navigation

- (void)viewDidLoad {
    _source = [YNQuestionDataSource source];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddFriend:) name:kYNAddedFriendNotification object:nil];
}

- (void)didAddFriend:(NSNotification *)notificaiton {
    [self.navigationController popViewControllerAnimated:YES];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_source numberOfUserRows];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end

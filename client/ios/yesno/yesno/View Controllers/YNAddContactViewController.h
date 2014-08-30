//
//  YNAddContactViewController.h
//  yesno
//
//  Created by Clay Reimann on 8/29/14.
//  Copyright (c) 2014 Sudo Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNAddContactViewController : UIViewController

@property (nonatomic) IBOutlet UITextField *name;
@property (nonatomic) IBOutlet UITextField *email;
@property (nonatomic) IBOutlet UITextField *phone;

- (IBAction)addContact:(id)sender;

@end

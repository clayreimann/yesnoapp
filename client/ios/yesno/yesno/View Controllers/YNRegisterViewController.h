//
//  YNRegisterViewController.h
//  yesno
//
//  Created by Clay Reimann on 8/25/14.
//  Copyright (c) 2014 Sudo Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNRegisterViewController : UIViewController

@property (nonatomic) IBOutlet UITextField *emailField;

- (IBAction)registerEmail:(id)sender;

@end

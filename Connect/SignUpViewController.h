//
//  SignUpViewController.h
//  Connect
//
//  Created by Billy Irwin on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *firstnameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastnameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *retypeTextField;
- (IBAction)cancel:(id)sender;
- (IBAction)signup:(id)sender;

@end

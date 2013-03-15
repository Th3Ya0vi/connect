//
//  ViewController.m
//  Connect
//
//  Created by Billy Irwin on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "ParseManager.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize tap;

- (void)viewDidLoad
{
    [super viewDidLoad];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"orange_background.png"]];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([[PFUser currentUser] isAuthenticated]) {
        [[ParseManager singleton] updateUser];
        [self performSegueWithIdentifier:LOGIN sender:self];
        NSLog(@"logging in as %@", [PFUser currentUser].username);
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)login:(id)sender 
{
    [PFUser logInWithUsernameInBackground:usernameTextField.text password:passwordTextField.text block:^(PFUser *user, NSError *error) {
        if (!error) {
            NSLog(@"current user: %@", [PFUser currentUser].username);
            [PFPush subscribeToChannelInBackground:[PFUser currentUser].username block:^(BOOL success, NSError *error) {
                [[ParseManager singleton] updateUser];
                [self performSegueWithIdentifier:LOGIN sender:self];
                usernameTextField.text = @"";
                passwordTextField.text = @"";
            }];
            
          
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (void)dismissKeyboard
{
    NSLog(@"dismiss keyboard");
    [self.view endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.view addGestureRecognizer:tap];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view removeGestureRecognizer:tap];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
     

@end

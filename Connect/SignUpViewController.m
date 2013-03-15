//
//  SignUpViewController.m
//  Connect
//
//  Created by Billy Irwin on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>

@interface SignUpViewController ()

@end

@implementation SignUpViewController
@synthesize usernameTextField;
@synthesize firstnameTextField;
@synthesize lastnameTextField;
@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize retypeTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"orange_background.png"]];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setUsernameTextField:nil];
    [self setFirstnameTextField:nil];
    [self setLastnameTextField:nil];
    [self setEmailTextField:nil];
    [self setPasswordTextField:nil];
    [self setRetypeTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)signup:(id)sender 
{
    if ([passwordTextField.text isEqualToString:retypeTextField.text]) {
        PFUser *theUser = [PFUser user];
        theUser.username = usernameTextField.text;
        theUser.password = passwordTextField.text;
        [theUser setValue:firstnameTextField.text forKey:FIRSTNAME];
        [theUser setValue:lastnameTextField.text forKey:LASTNAME];
        [theUser setValue:emailTextField.text forKey:EMAIL];
        [theUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                NSLog(@"signup successful");
                
                NSArray *friends = [[NSArray alloc] init];
                NSArray *groups = [[NSArray alloc] init];
                NSArray *events = [[NSArray alloc] init];
                NSArray *requests = [[NSArray alloc] init];
                
                PFObject *g = [PFObject objectWithClassName:GROUPS_BOX];
                [g setValue:groups forKey:GROUPS];
                [g setValue:usernameTextField.text forKey:USERNAME];
                
                
                PFObject *f = [PFObject objectWithClassName:FRIENDS_BOX];
                [f setValue:friends forKey:FRIENDS];
                [f setValue:usernameTextField.text forKey:USERNAME];                
                
                PFObject *e = [PFObject objectWithClassName:EVENTS_BOX];
                [e setValue:events forKey:EVENTS];
                [e setValue:usernameTextField.text forKey:USERNAME];
                                             
                PFObject *r = [PFObject objectWithClassName:REQUESTS_BOX];
                [r setValue:requests forKey:REQUESTS];
                [r setValue:usernameTextField.text forKey:USERNAME];
                               
                NSArray *array = [[NSArray alloc] initWithObjects:g, f, e, r, nil];
                [PFObject saveAllInBackground:array block:^ (BOOL success, NSError *error) {
                    if (!error) {
                        NSMutableDictionary *ids = [[NSMutableDictionary alloc] init];
                        NSLog(@"recently created group box id: %@", g.objectId);
                        [ids setObject:g.objectId forKey:GROUPS_BOX];
                        [ids setObject:f.objectId forKey:FRIENDS_BOX];
                        [ids setObject:r.objectId forKey:REQUESTS_BOX];
                        [ids setObject:e.objectId forKey:EVENTS_BOX];
                        
                        [theUser setObject:ids forKey:@"boxIds"];
                        
                        [theUser saveInBackgroundWithBlock:^ (BOOL success, NSError *error) {
                            [PFPush subscribeToChannelInBackground:usernameTextField.text block:^(BOOL succeeded, NSError *error) {
                              
                                    
                                    [self dismissModalViewControllerAnimated:YES];
                               
                            }];
                        }];
                        
                    } else {
                        NSString *errorString = [[error userInfo] objectForKey:@"error"];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                                        message:errorString
                                                                       delegate:self 
                                                              cancelButtonTitle:@"OK" 
                                                              otherButtonTitles:nil, nil];
                        [alert show];
                        retypeTextField.text = @"";
                        passwordTextField.text = @"";
                    }

                    
                }];               

                
            } else {
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                                message:errorString
                                                               delegate:self 
                                                      cancelButtonTitle:@"OK" 
                                                      otherButtonTitles:nil, nil];
                [alert show];
                retypeTextField.text = @"";
                passwordTextField.text = @"";
            }
        }];
        
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Passwords Do Not Match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
@end

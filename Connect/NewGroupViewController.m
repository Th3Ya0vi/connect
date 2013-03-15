//
//  NewGroupViewController.m
//  Connect
//
//  Created by Billy Irwin on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewGroupViewController.h"

@interface NewGroupViewController ()

@end

@implementation NewGroupViewController
@synthesize groupScrollView;
@synthesize nameTextField;
@synthesize descriptionTextView;
@synthesize chosenFriends;
@synthesize tap;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        chosenFriends = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTouched)];
    [self.headerView removeFromSuperview];
    groupScrollView.contentSize = CGSizeMake(320, 500);
    self.headerLabel.text = @"Add Group";
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [self setDescriptionTextView:nil];
    [self setGroupScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)finishedSendingInvites:(NSError *)error
{
    if (!error) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self displayAlertforError:error];
    }
}

- (IBAction)inviteFriends:(id)sender 
{
    [self performSegueWithIdentifier:CHOOSEFRIENDS sender:self];
}

- (IBAction)createGroup:(id)sender {
    
    NSLog(@"creating group");
    PFObject *group = [PFObject objectWithClassName:GROUP];
    [group setObject:nameTextField.text forKey:NAME];
    [group setObject:descriptionTextView.text forKey:DESCRIPTION];
    [group setObject:[NSArray array] forKey:MESSAGES];
    [group setObject:[NSArray arrayWithObject:[PFUser currentUser]] forKey:USERS];
    [group setObject:[PFUser currentUser].username forKey:CREATOR];
    [group setObject:[NSDate date] forKey:DATE];
    
    [group saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
        if (!error) {
            NSMutableDictionary *groupRequest = [[NSMutableDictionary alloc] init];
            [groupRequest setObject:nameTextField.text forKey:NAME];
            [groupRequest setObject:descriptionTextView.text forKey:DESCRIPTION];
            [groupRequest setObject:[PFUser currentUser].username forKey:CREATOR];
            [groupRequest setObject:group.objectId forKey:ID];
            [groupRequest setObject:GROUP forKey:@"type"];
            [[ParseManager singleton] sendOutGroupRequestsforGroup:groupRequest includeSelf:YES toFriends:chosenFriends withCallbackKey:self.delegateId];
        }
    }];
}

- (IBAction)cancelCreateGroup:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)finishedChoosingFriends:(NSArray *)friends withCancelValue:(BOOL)cancel
{
    [self dismissViewControllerAnimated:YES completion:^ {
        if (!cancel) {
            chosenFriends = friends;
 
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:CHOOSEFRIENDS]) {
        FriendPickerViewController *f = segue.destinationViewController;
        f.delegate = self;
        f.previouslySelected = chosenFriends;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.groupScrollView addGestureRecognizer:tap];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.groupScrollView removeGestureRecognizer:tap];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.groupScrollView addGestureRecognizer:tap];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.groupScrollView removeGestureRecognizer:tap];
}

- (void)backgroundTouched
{
    NSLog(@"background touched");
    [self.view endEditing:YES];
}

@end

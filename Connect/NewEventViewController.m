//
//  NewEventViewController.m
//  Connect
//
//  Created by Billy Irwin on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewEventViewController.h"

@interface NewEventViewController ()

@end

@implementation NewEventViewController
@synthesize eventDatePicker;
@synthesize eventScrollView;
@synthesize nameTextField;
@synthesize descriptionTextView;
@synthesize timeChooserView;
@synthesize chosenFriends;
@synthesize chosenDate;
@synthesize dateLabel;
@synthesize tap;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        chosenFriends = [[NSArray alloc] init];
        chosenDate = [[NSDate alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTouched)];
    dateLabel.text = @"";
    [self.headerView removeFromSuperview];
    eventScrollView.contentSize = CGSizeMake(320, 500);
    self.headerLabel.text = @"Add Event";
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [self setDescriptionTextView:nil];
    [self setTimeChooserView:nil];
    [self setEventDatePicker:nil];
    [self setEventScrollView:nil];
    [self setDateLabel:nil];
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

- (IBAction)chooseDate:(id)sender 
{
    [UIView animateWithDuration:1.0 animations:^ {
        timeChooserView.frame = CGRectMake(0, 460, 320, 250);
    }];
    
    NSDate *selectedDate = [eventDatePicker date];
    chosenDate = selectedDate;
    [self updateDateLabel];    
}

- (void)updateDateLabel
{
    dateLabel.text = [NSDateFormatter localizedStringFromDate:chosenDate dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
}

- (IBAction)cancelChooseDate:(id)sender 
{
    [UIView animateWithDuration:1.0 animations:^ {
        timeChooserView.frame = CGRectMake(0, 460, 320, 250);
    }];
}

- (IBAction)addDate:(id)sender 
{
    [UIView animateWithDuration:1.0 animations:^ {
        timeChooserView.frame = CGRectMake(0, 210, 320, 250);
    }];
}
- (IBAction)inviteFriends:(id)sender 
{
    [self performSegueWithIdentifier:CHOOSEFRIENDS sender:self];
}

- (IBAction)createEvent:(id)sender {
    
    PFObject *event = [PFObject objectWithClassName:EVENT];
    [event setObject:nameTextField.text forKey:NAME];
    [event setObject:descriptionTextView.text forKey:DESCRIPTION];
    [event setObject:[NSArray array] forKey:MESSAGES];
    [event setObject:[NSArray arrayWithObject:[PFUser currentUser]] forKey:USERS];
    [event setObject:[PFUser currentUser].username forKey:CREATOR];
    [event setObject:chosenDate forKey:DATE];
    
    NSMutableDictionary *attendance = [NSMutableDictionary dictionary];
    for (PFUser *user in chosenFriends) {
        [attendance setObject:[NSNumber numberWithInt:0] forKey:user.username];
    }
    
    [attendance setObject:[NSNumber numberWithInt:1] forKey:[PFUser currentUser].username];
    
    [event setObject:attendance forKey:ATTENDING];
   
    [event saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
        if (!error) {
            NSMutableDictionary *eventRequest = [[NSMutableDictionary alloc] init];
            [eventRequest setObject:nameTextField.text forKey:NAME];
            [eventRequest setObject:descriptionTextView.text forKey:DESCRIPTION];
            [eventRequest setObject:[PFUser currentUser].username forKey:CREATOR];
            [eventRequest setObject:chosenDate forKey:DATE];
            [eventRequest setObject:event.objectId forKey:ID];
            [eventRequest setObject:EVENT forKey:@"type"];
            [[ParseManager singleton] sendOutEventRequestsforEvent:eventRequest includeSelf:YES toFriends:chosenFriends withCallbackKey:self.delegateId];
        } else {
            [self displayAlertforError:error];
        }
    }];
}

- (IBAction)cancelCreateEvent:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)finishedChoosingFriends:(NSArray *)friends withCancelValue:(BOOL)cancel
{
    [self dismissViewControllerAnimated:YES completion:^ {
        if (!cancel) {
            chosenFriends = friends;
            
            for (PFUser *user in chosenFriends) {
                NSLog(@"%@", [user objectForKey:USERNAME]);
            }
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
    [self.eventScrollView addGestureRecognizer:tap];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.eventScrollView removeGestureRecognizer:tap];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.eventScrollView addGestureRecognizer:tap];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.eventScrollView removeGestureRecognizer:tap];
}

- (void)backgroundTouched
{
    NSLog(@"background touched");
    [self.view endEditing:YES];
}
@end

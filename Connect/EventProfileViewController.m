//
//  EventProfileViewController.m
//  Connect
//
//  Created by Billy Irwin on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventProfileViewController.h"
#import "FriendViewerViewController.h"

@interface EventProfileViewController ()

@end

@implementation EventProfileViewController
@synthesize wallPostTextField;
@synthesize nameLabel;
@synthesize descriptionLabel;
@synthesize dateLabel;
@synthesize wallpostView;
@synthesize wallpostTableView;
@synthesize event;
@synthesize doneLoading;
@synthesize wallPosts;
@synthesize attendingLabel;
@synthesize undecidedLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        doneLoading = NO;
        wallPosts = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self reloadViews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showBackButton];
    self.backTitle.text = @"Back";
    nameLabel.text = @"";
    descriptionLabel.text = @"";
    dateLabel.text = @"";
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [self setDescriptionLabel:nil];
    [self setDateLabel:nil];
    [self setWallpostView:nil];
    [self setWallpostTableView:nil];
    [self setWallPostTextField:nil];
    [self setAttendingLabel:nil];
    [self setUndecidedLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)reloadViews
{
    nameLabel.text = [event objectForKey:NAME];
    descriptionLabel.text = [event objectForKey:DESCRIPTION];
    dateLabel.text = [NSDateFormatter localizedStringFromDate:[event objectForKey:DATE] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
    wallPosts = [event objectForKey:MESSAGES];
    [wallpostTableView reloadData];
    
    int a = 0;
    int u = 0;
    
    
    for (NSNumber *n in [[event objectForKey:ATTENDING] allObjects]) {
        if ([n intValue] == 1) {
            a++;
        } else if ([n intValue] == 0) {
            u++;
        }
    }
    
    attendingLabel.text = [NSString stringWithFormat:@"Attending: %i", a];
    undecidedLabel.text = [NSString stringWithFormat:@"Undecided: %i", u];
}

- (IBAction)showUsers:(id)sender 
{
    [PFObject fetchAllIfNeededInBackground:[event objectForKey:USERS] block:^(NSArray *users, NSError *error) {
        if (!error) {
            [self performSegueWithIdentifier:LOADEVENTFRIENDS sender:self];
        }
    }];
}

- (IBAction)displayWallPosts:(id)sender {
    [UIView animateWithDuration:1.0 animations:^ {
        wallpostView.frame = CGRectMake(0, 100, 320, 360);
    }];
}

- (IBAction)postMessage:(id)sender 
{
    if (![wallPostTextField.text isEqualToString:@""]) {
        [self.view endEditing:YES];
        NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys:wallPostTextField.text, CONTENT, [PFUser currentUser].username, NAME, nil];
        [event addObject:message forKey:MESSAGES];
        [wallPosts insertObject:message atIndex:0];
        [event saveInBackground];
        [wallpostTableView reloadData];
        wallPostTextField.text = @"";
    }
}

- (IBAction)doneViewPosts:(id)sender {
    [UIView animateWithDuration:1.0 animations:^ {
        wallpostView.frame = CGRectMake(0, 460, 320, 360);
    }];
}

- (IBAction)attending:(id)sender 
{
    [[event objectForKey:ATTENDING] setObject:[NSNumber numberWithInt:1] forKey:[PFUser currentUser].username];
    [event saveInBackground];
    [self reloadViews];
}

- (IBAction)notAttending:(id)sender {
    [[event objectForKey:ATTENDING] setObject:[NSNumber numberWithInt:2] forKey:[PFUser currentUser].username];
    [event saveInBackground];
    [self reloadViews];
}

- (IBAction)inviteFriends:(id)sender {
    [self performSegueWithIdentifier:CHOOSEFRIENDS sender:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [wallPosts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        UITableViewCell *cell = [self.wallpostTableView dequeueReusableCellWithIdentifier:WALLPOSTCELL];
        
        UILabel *name = (UILabel *)[cell viewWithTag:1];
        UILabel *content = (UILabel *)[cell viewWithTag:2];
        
        name.text = [[wallPosts objectAtIndex:indexPath.row] objectForKey:NAME];
        content.text = [[wallPosts objectAtIndex:indexPath.row] objectForKey:CONTENT];
        return cell;
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:LOADEVENTFRIENDS]) {
        FriendViewerViewController *f = [segue destinationViewController];
        f.friends = [event objectForKey:USERS];
        f.attending = [event objectForKey:ATTENDING];
    } else if ([segue.identifier isEqualToString:CHOOSEFRIENDS]) {
        FriendPickerViewController *f = segue.destinationViewController;
        f.delegate = self;
    }
}

- (void)finishedChoosingFriends:(NSArray *)friends withCancelValue:(BOOL)cancel
{
    [self dismissViewControllerAnimated:YES completion:^ {
        if (!cancel) {
            NSMutableDictionary *eventRequest = [[NSMutableDictionary alloc] init];
            [eventRequest setObject:[event objectForKey:NAME] forKey:NAME];
            [eventRequest setObject:[event objectForKey:DESCRIPTION] forKey:DESCRIPTION];
            [eventRequest setObject:[event objectForKey:CREATOR] forKey:CREATOR];
            [eventRequest setObject:[event objectForKey:DATE] forKey:DATE];
            [eventRequest setObject:event.objectId forKey:ID];
            [eventRequest setObject:EVENT forKey:@"type"];
            [[ParseManager singleton] sendOutEventRequestsforEvent:eventRequest includeSelf:NO toFriends:friends withCallbackKey:self.delegateId];
        }
    }];
}

- (void)finishedSendingInvites:(NSError *)error
{
    if (!error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Invites Delivered" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        [self displayAlertforError:error];
    }
}
@end

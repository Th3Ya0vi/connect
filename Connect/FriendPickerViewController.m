//
//  FriendPickerViewController.m
//  Connect
//
//  Created by Billy Irwin on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendPickerViewController.h"
#import "ParseManager.h"

@interface FriendPickerViewController ()

@end

@implementation FriendPickerViewController
@synthesize friendPickerTableView;
@synthesize delegate;
@synthesize friends;
@synthesize selectedLabel;
@synthesize previouslySelected;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        friends = [[NSArray alloc] init];
        previouslySelected = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.headerView removeFromSuperview];
    [[ParseManager singleton] loadFriendsForUser:[PFUser currentUser] WithCallbackKey:self.delegateId];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setFriendPickerTableView:nil];
    [self setSelectedLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)finishedFetchingFriends:(NSArray *)objects withError:(NSError *)error
{
    if (!error) {
        friends = objects;
        [friendPickerTableView reloadData];
    } else {
        [self displayAlertforError:error];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.friendPickerTableView dequeueReusableCellWithIdentifier:FRIENDPICKERCELL];
    
    PFUser *friend = [friends objectAtIndex:indexPath.row];
    
    UILabel *name = (UILabel *)[cell viewWithTag:1];
    name.text = [friend objectForKey:USERNAME];
    
    if ([previouslySelected containsObject:friend]) {
        [friendPickerTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self updateSelectedLabel];
}

- (void)updateSelectedLabel
{
    int numSelected = [[friendPickerTableView indexPathsForSelectedRows] count];
    selectedLabel.text = [NSString stringWithFormat:@"Selected: %i", numSelected];
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


- (IBAction)finished:(id)sender 
{
    NSMutableArray *chosen = [[NSMutableArray alloc] init];    
    for (NSIndexPath *index in [friendPickerTableView indexPathsForSelectedRows]) {
        [chosen addObject:[friends objectAtIndex:index.row]];
    }
    
    [delegate finishedChoosingFriends:chosen withCancelValue:NO];
}

- (IBAction)cancel:(id)sender 
{
    [delegate finishedChoosingFriends:nil withCancelValue:YES];
}
@end

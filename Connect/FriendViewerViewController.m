//
//  FriendViewerViewController.m
//  Connect
//
//  Created by Billy Irwin on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendViewerViewController.h"
#import "FriendProfileViewController.h"
@interface FriendViewerViewController ()

@end

@implementation FriendViewerViewController
@synthesize friendTableView;
@synthesize friends;
@synthesize attending;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        friends = [[NSMutableArray alloc] init];
        attending = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [friendTableView deselectRowAtIndexPath:[friendTableView indexPathForSelectedRow] animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backTitle.text = @"Back";
    self.headerLabel.text = @"Friends";
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setFriendTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    UITableViewCell *cell = [self.friendTableView dequeueReusableCellWithIdentifier:FRIENDVIEWERCELL];
    
    PFUser *friend = [friends objectAtIndex:indexPath.row];
    
    UILabel *name = (UILabel *)[cell viewWithTag:1];
    name.text = [friend objectForKey:USERNAME];
    UIButton *add = (UIButton *)[cell viewWithTag:3]; 
 
    
    if ([name.text isEqualToString:[PFUser currentUser].username]) {
        name.text = @"You";
        //add.titleLabel.text = @"";
    }
    
    NSLog(@"add.tag = %i", add.tag);

    return cell;
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:LOADFRIEND sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FriendProfileViewController *f = [segue destinationViewController];
    f.theFriend = [friends objectAtIndex:[friendTableView indexPathForSelectedRow].row];
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



- (IBAction)addFriend:(UIButton *)sender 
{
    NSString *search_user = [[friends objectAtIndex:sender.tag] objectForKey:NAME];
    NSLog(@"friend requesting %@", search_user);
    PFQuery *query = [PFQuery queryWithClassName:REQUESTS_BOX];
    [query whereKey:USERNAME equalTo:search_user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (!error) {
            NSLog(@"results count: %i", [results count]);
            if ([results count]!=0) {
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[PFUser currentUser].username, NAME, [[[PFUser currentUser] objectForKey:BOXIDS] objectForKey:FRIENDS_BOX], FRIENDBOXID, [[[PFUser currentUser] objectForKey:BOXIDS] objectForKey:REQUESTS_BOX], REQUESTBOXID, nil];
                [[results objectAtIndex:0] addObject:dict forKey:FRIENDREQUESTS];
                [[results objectAtIndex:0] saveInBackground];
            } else {
                [self displayNoUserError];
            }
        } else {
            [self displayAlertforError:error];
        }
    }];
}

- (void)displayNoUserError 
{
    UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No user with username: ASDFSD" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert2 show];
}
@end

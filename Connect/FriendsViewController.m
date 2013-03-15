//
//  FriendsViewController.m
//  Connect
//
//  Created by Billy Irwin on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface FriendsViewController ()

@end

@implementation FriendsViewController
@synthesize friendsTableView;
@synthesize searchView;
@synthesize searchTextField;
@synthesize friends;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        friends = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [friendsTableView deselectRowAtIndexPath:[friendsTableView indexPathForSelectedRow] animated:NO];
    [[ParseManager singleton] loadFriendsForUser:[PFUser currentUser] WithCallbackKey:self.delegateId];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    friendsTableView.frame = CGRectMake(0, 70, 320, 390);
    searchView.frame = CGRectMake(0, 20, 320, 40);
    [self.view bringSubviewToFront:self.headerView];
    self.headerLabel.text = @"Friends";
    self.title = @"Friends";
    //[[ParseManager singleton] loadFriendsForUser:[PFUser currentUser].username WithCallbackKey:self.delegateId];
    

    UIButton *addFriend = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
    [addFriend setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [addFriend addTarget:self action:@selector(showSearchBar) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:addFriend];
    
    
	// Do any additional setup after loading the view.
}


- (void)viewDidUnload
{
    [self setFriendsTableView:nil];
    [self setSearchView:nil];
    [self setSearchTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)parseManagerFinishedLoading:(NSError *)error forAction:(int)action
{
    NSLog(@"finished loading friends");
    if (!error) {
        friends = [[ParseManager singleton] friendsBox];
        [friendsTableView reloadData];
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
    UITableViewCell *cell = [self.friendsTableView dequeueReusableCellWithIdentifier:FRIENDCELL];
    
    UILabel *name = (UILabel *)[cell viewWithTag:1];
    name.text = [[friends objectAtIndex:indexPath.row] objectForKey:USERNAME];

    UIImageView *proPic = (UIImageView *)[cell viewWithTag:2];
    PFFile *file = [[friends objectAtIndex:indexPath.row] objectForKey:@"profilePicture"];
    
    proPic.image = [UIImage imageWithData:[file getData]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:LOADFRIEND sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FriendProfileViewController *f = [segue destinationViewController];
    f.theFriend = [friends objectAtIndex:[friendsTableView indexPathForSelectedRow].row];
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

- (void)showSearchBar
{
    [UIView animateWithDuration:0.5 animations:^{
        friendsTableView.frame = CGRectMake(0, 110, 320, 330);
        searchView.frame = CGRectMake(0, 60, 320, 40);
    }];
    
}

- (IBAction)sendRequest:(id)sender 
{
    
}

- (IBAction)cancelRequest:(id)sender 
{
    [UIView animateWithDuration:0.5 animations:^{
        friendsTableView.frame = CGRectMake(0, 70, 320, 390);
        searchView.frame = CGRectMake(0, 20, 320, 40);
    }];
    
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *search_user = [searchTextField.text 
                             stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    PFQuery *query = [PFQuery queryWithClassName:REQUESTS_BOX];
    [query whereKey:USERNAME equalTo:search_user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (!error) {
            NSLog(@"results count: %i", [results count]);
            if ([results count]!=0) {
                NSMutableDictionary *friendRequest = [[NSMutableDictionary alloc] init];
                [friendRequest setObject:[PFUser currentUser].username forKey:NAME];
                [friendRequest setObject:[[[PFUser currentUser] objectForKey:BOXIDS]
                                           objectForKey:FRIENDS_BOX] forKey:FRIENDBOXID];
                [friendRequest setObject:[PFUser currentUser].objectId forKey:ID];
                [friendRequest setObject:FRIENDS forKey:@"type"];
                [[results objectAtIndex:0] addObject:friendRequest forKey:REQUESTS];
                [[results objectAtIndex:0] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    [PFPush sendPushMessageToChannelInBackground:search_user withMessage:@"New Friend Requests"];
                }];
            } else {
                [self displayNoUserError];
            }
        } else {
            [self displayAlertforError:error];
        }
    }];

    
    [self cancelRequest:nil];
    return YES;
}

- (void)displayNoUserError 
{
    UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No user with username: ASDFSD" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert2 show];
}

- (void)finishedFetchingFriends:(NSArray *)objects withError:(NSError *)error
{
    if (!error) {
        friends = objects;
        [friendsTableView reloadData];
    }
}

@end

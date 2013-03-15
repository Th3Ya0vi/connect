//
//  GroupProfileViewController.m
//  Connect
//
//  Created by Billy Irwin on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GroupProfileViewController.h"
#import "FriendViewerViewController.h"
@interface GroupProfileViewController ()

@end

@implementation GroupProfileViewController
@synthesize wallPostTextField;
@synthesize nameLabel;
@synthesize descriptionLabel;
@synthesize wallpostView;
@synthesize wallpostTableView;
@synthesize group;
@synthesize doneLoading;
@synthesize wallPosts;

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
    self.backTitle.text = @"groups";
    nameLabel.text = @"";
    descriptionLabel.text = @"";
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [self setDescriptionLabel:nil];
    [self setWallpostView:nil];
    [self setWallpostTableView:nil];
    [self setWallPostTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)reloadViews
{
    nameLabel.text = [group objectForKey:NAME];
    descriptionLabel.text = [group objectForKey:DESCRIPTION];
    wallPosts = [group objectForKey:MESSAGES];
    wallPosts = (NSMutableArray *)[[wallPosts reverseObjectEnumerator] allObjects];
    [wallpostTableView reloadData];
}

- (IBAction)inviteFriends:(id)sender {
    [self performSegueWithIdentifier:CHOOSEFRIENDS sender:self];
}

- (IBAction)showUsers:(id)sender
{
    [PFObject fetchAllIfNeededInBackground:[group objectForKey:USERS] block:^(NSArray *users, NSError *error) {
        if (!error) {
            [self performSegueWithIdentifier:LOADGROUPFRIENDS sender:self];
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
    [self.view endEditing:YES];
    NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys:wallPostTextField.text, CONTENT, [PFUser currentUser].username, NAME, nil];
    [group addObject:message forKey:MESSAGES];
    [wallPosts insertObject:message atIndex:0];
    [group saveInBackground];
    [wallpostTableView reloadData];
    wallPostTextField.text = @"";
}

- (IBAction)doneViewPosts:(id)sender {
    [UIView animateWithDuration:1.0 animations:^ {
        wallpostView.frame = CGRectMake(0, 460, 320, 360);
    }];
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
    if ([segue.identifier isEqualToString:LOADGROUPFRIENDS]) {
        FriendViewerViewController *f = [segue destinationViewController];
        f.friends = [group objectForKey:USERS];
        f.attending = [group objectForKey:ATTENDING];
    } else if ([segue.identifier isEqualToString:CHOOSEFRIENDS]) {
        FriendPickerViewController *f = segue.destinationViewController;
        f.delegate = self;
    }
}

- (void)finishedChoosingFriends:(NSArray *)friends withCancelValue:(BOOL)cancel
{
    [self dismissViewControllerAnimated:YES completion:^ {
        if (!cancel) {
            NSMutableDictionary *groupRequest = [[NSMutableDictionary alloc] init];
            [groupRequest setObject:[group objectForKey:NAME] forKey:NAME];
            [groupRequest setObject:[group objectForKey:DESCRIPTION] forKey:DESCRIPTION];
            [groupRequest setObject:[group objectForKey:CREATOR] forKey:CREATOR];
            [groupRequest setObject:[group objectForKey:DATE] forKey:DATE];
            [groupRequest setObject:group.objectId forKey:ID];
            [groupRequest setObject:GROUP forKey:@"type"];
            [[ParseManager singleton] sendOutGroupRequestsforGroup:groupRequest includeSelf:NO toFriends:friends withCallbackKey:self.delegateId];
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

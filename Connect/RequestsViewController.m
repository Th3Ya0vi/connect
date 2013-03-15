//
//  RequestsViewController.m
//  Connect
//
//  Created by Billy Irwin on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestsViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface RequestsViewController ()

@end

@implementation RequestsViewController
@synthesize requestsTableView;
@synthesize groupRequests, friendRequests, eventRequests;
@synthesize requestsBox;
@synthesize selectedItemRow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[ParseManager singleton] loadRequestsForUser:[PFUser currentUser] WithCallbackKey:self.delegateId];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    groupRequests = [[NSMutableArray alloc] init];
    friendRequests = [[NSMutableArray alloc] init];
    eventRequests = [[NSMutableArray alloc] init];
    requestsTableView.layer.cornerRadius = 15;
    self.title = @"Home";
    self.headerLabel.text = @"Requests";
    // Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setRequestsTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)finishedFetchingRequests:(NSArray *)objects withError:(NSError *)error
{
    if (!error) {
        NSLog(@"organizing %i requests", [objects count]);
        [friendRequests removeAllObjects];
        [groupRequests removeAllObjects];
        [eventRequests removeAllObjects];
        
        for (id object in objects) {
            if ([[object objectForKey:@"type"] isEqualToString:EVENT]) {
                NSLog(@"event request found");
                [eventRequests addObject:object];
            } else if ([[object objectForKey:@"type"] isEqualToString:GROUP]) {
                NSLog(@"group request found");
                [groupRequests addObject:object];
            } else {
                NSLog(@"friend request found");
                NSLog(@"%@", [object class]);
                [friendRequests addObject:object];
            }
        }
        
        
        NSLog(@"groups: %i   events: %i   friends: %i", [groupRequests count], [eventRequests count], [friendRequests count]);
        [requestsTableView reloadData];
        
    } else {
        
        [self displayAlertforError:error];
    }
}

- (void)finishedRespondingToRequest:(int)type withError:(NSError *)error
{
    if (!error) {
        if (type == 1) {
            [friendRequests removeObject:[friendRequests objectAtIndex:selectedItemRow]];
        } else if (type == 2) {
            [eventRequests removeObject:[eventRequests objectAtIndex:selectedItemRow]];
        } else {
            [groupRequests removeObject:[groupRequests objectAtIndex:selectedItemRow]];
        }
        
        [requestsTableView reloadData];
        
    } else {
        [self displayAlertforError:error];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Friend Requests";
            break;
        case 1:
            return @"Event Requests";
            break;
        case 2:
            return @"Group Requests";
            break;
        default:
            return 0;
            break;
    }}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [friendRequests count];
            break;
        case 1:
            return [eventRequests count];
            break;
        case 2:
            return [groupRequests count];
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
  
        UITableViewCell *cell = [self.requestsTableView dequeueReusableCellWithIdentifier:FRIEND_REQUEST_CELL];
    
        UILabel *name = (UILabel *)[cell viewWithTag:1];
        name.text = [[friendRequests objectAtIndex:indexPath.row] objectForKey:NAME];
        
        UIButton *acceptButton = (UIButton *)[cell viewWithTag:2];
        acceptButton.tag = indexPath.row;
        UIButton *rejectButton = (UIButton *)[cell viewWithTag:3];
        rejectButton.tag = indexPath.row;
 
        return cell;
        
    } else if (indexPath.section == 1) {
        
        UITableViewCell *cell = [self.requestsTableView dequeueReusableCellWithIdentifier:EVENT_REQUEST_CELL];
        
        UILabel *name = (UILabel *)[cell viewWithTag:1];
        name.text = [[eventRequests objectAtIndex:indexPath.row] objectForKey:NAME];
        
        UIButton *acceptButton = (UIButton *)[cell viewWithTag:2];
        acceptButton.tag = indexPath.row;
        UIButton *rejectButton = (UIButton *)[cell viewWithTag:3];
        rejectButton.tag = indexPath.row;
        
        return cell;
        
    } else {
        
        UITableViewCell *cell = [self.requestsTableView dequeueReusableCellWithIdentifier:GROUP_REQUEST_CELL];
        
        UILabel *name = (UILabel *)[cell viewWithTag:1];
        name.text = [[groupRequests objectAtIndex:indexPath.row] objectForKey:NAME];
        
        UIButton *acceptButton = (UIButton *)[cell viewWithTag:2];
        acceptButton.tag = indexPath.row;
        UIButton *rejectButton = (UIButton *)[cell viewWithTag:3];
        rejectButton.tag = indexPath.row;
        
        return cell;
    }

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

- (IBAction)acceptFriend:(UIButton *)sender 
{
    NSDictionary *selectedFriend = [friendRequests objectAtIndex:sender.tag];
    NSLog(@"%i", sender.tag);
    selectedItemRow = sender.tag;
    [[ParseManager singleton] acceptFriend:selectedFriend withCallbackKey:self.delegateId];
}

- (IBAction)rejectFriend:(UIButton *)sender 
{
    NSMutableDictionary *selectedFriend = [friendRequests objectAtIndex:sender.tag];
    NSLog(@"%i", sender.tag);
    selectedItemRow = sender.tag;
    [[ParseManager singleton] rejectFriend:selectedFriend withCallbackKey:self.delegateId];
}

- (IBAction)acceptEvent:(UIButton *)sender 
{
   
    NSMutableDictionary *event = [eventRequests objectAtIndex:sender.tag];
    NSLog(@"%i", sender.tag);
    selectedItemRow = sender.tag;
    [[ParseManager singleton] acceptEvent:event withCallbackKey:self.delegateId];

}

- (IBAction)rejectEvent:(UIButton *)sender 
{
    NSMutableDictionary *event = [eventRequests objectAtIndex:sender.tag];
    NSLog(@"%i", sender.tag);
    selectedItemRow = sender.tag;
    [[ParseManager singleton] rejectEvent:event withCallbackKey:self.delegateId];

}
- (IBAction)acceptGroup:(UIButton *)sender 
{
    NSMutableDictionary *group = [groupRequests objectAtIndex:sender.tag];
    NSLog(@"%i", sender.tag);
    selectedItemRow = sender.tag;
    [[ParseManager singleton] acceptGroup:group withCallbackKey:self.delegateId];
}

- (IBAction)rejectGroup:(UIButton *)sender 
{
    NSMutableDictionary *group = [groupRequests objectAtIndex:sender.tag];
    NSLog(@"%i", sender.tag);
    selectedItemRow = sender.tag;
    [[ParseManager singleton] rejectGroup:group withCallbackKey:self.delegateId];

}
@end

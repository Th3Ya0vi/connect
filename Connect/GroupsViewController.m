//
//  GroupsViewController.m
//  Connect
//
//  Created by Billy Irwin on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GroupsViewController.h"
#import "GroupProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface GroupsViewController ()

@end

@implementation GroupsViewController

@synthesize reloading;
@synthesize groupsTableView;
@synthesize groups;
@synthesize refreshHeaderView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        groups = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES]; 
    [groupsTableView deselectRowAtIndexPath:[groupsTableView indexPathForSelectedRow] animated:NO];
    [[ParseManager singleton] loadGroupsForUser:[PFUser currentUser] WithCallbackKey:self.delegateId];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    
    UIButton *addFriend = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
    [addFriend setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [addFriend addTarget:self action:@selector(createGroup) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:addFriend];
    
    self.title = @"Groups";
    self.headerLabel.text = @"Groups";
    
    refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 
                                                                                    0.0f - self.groupsTableView.bounds.size.height, 
                                                                                    self.view.frame.size.width, 
                                                                                    self.groupsTableView.bounds.size.height)];
    refreshHeaderView.delegate = self;
    [groupsTableView addSubview:refreshHeaderView]; 
    // Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setGroupsTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)finishedFetchingGroups:(NSArray *)objects withError:(NSError *)error
{
    if (!error) {
        groups = objects;
        [groupsTableView reloadData];
    } else {
        [self displayAlertforError:error];
    }
}

- (void)parseManagerFinishedLoading:(NSError *)error forAction:(int)action
{  
    NSLog(@"finished loading groups");
    if (!error) {
        groups = [[ParseManager singleton] groupsBox];
        [groupsTableView reloadData];
    } else {
        [self displayAlertforError:error];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [groups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.groupsTableView dequeueReusableCellWithIdentifier:GROUPCELL];
    
    UILabel *name = (UILabel *)[cell viewWithTag:1];
    
    name.text = [[groups objectAtIndex:indexPath.row] objectForKey:NAME];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:LOADGROUP sender:self];
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

- (void)createGroup
{
    [self performSegueWithIdentifier:CREATEGROUP sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:LOADGROUP]) {
        PFObject *group = [groups objectAtIndex:[groupsTableView indexPathForSelectedRow].row];
        GroupProfileViewController *g = [segue destinationViewController];
        g.group= group;
    }
}

- (void)reloadTableViewDataSource
{
    
	reloading = YES;
    
    [[ParseManager singleton] loadGroupsForUser:[PFUser currentUser] WithCallbackKey:self.delegateId];

    [self doneLoadingTableViewData];
    
}

- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
	reloading = NO;
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:groupsTableView];
}


#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
    
	[refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
	[refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}


#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
	[self performSelectorOnMainThread:@selector(reloadTableViewDataSource) withObject:nil waitUntilDone:NO];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
	return reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
	return [NSDate date]; // should return date data source was last changed
    
}@end

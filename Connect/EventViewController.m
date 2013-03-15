//
//  EventViewController.m
//  Connect
//
//  Created by Billy Irwin on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventViewController.h"
#import "NewEventViewController.h"
#import "EventProfileViewController.h"

@interface EventViewController ()

@end

@implementation EventViewController
@synthesize eventsTableView;
@synthesize events;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        events = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [eventsTableView deselectRowAtIndexPath:[eventsTableView indexPathForSelectedRow] animated:NO];
    [[ParseManager singleton] loadEventsForUser:[PFUser currentUser] WithCallbackKey:self.delegateId];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Home";
    self.headerLabel.text = @"Events";
    
    UIButton *addEvent = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
    [addEvent setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [addEvent addTarget:self action:@selector(showAddEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:addEvent];


    // Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setEventsTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)finishedFetchingEvents:(NSArray *)objects withError:(NSError *)error
{
    if (!error) {
        events = objects;
        [eventsTableView reloadData];
    } else {
        [self displayAlertforError:error];
    }
}

- (void)parseManagerFinishedLoading:(NSError *)error forAction:(int)action
{
NSLog(@"finished loading events");
    if (!error) {
        events = [[ParseManager singleton] eventsBox];
        [eventsTableView reloadData];
    } else {
        [self displayAlertforError:error];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.eventsTableView dequeueReusableCellWithIdentifier:@"eventCell"];
    
    UILabel *name = (UILabel *)[cell viewWithTag:1];
    UILabel *date = (UILabel *)[cell viewWithTag:2];
    
    name.text = [[events objectAtIndex:indexPath.row] objectForKey:NAME];
    NSDate *eventDate = [[events objectAtIndex:indexPath.row] objectForKey:DATE];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    date.text = [dateFormatter stringFromDate:eventDate];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:DISPLAYEVENT sender:self];
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

- (void)showAddEvent
{
    [self performSegueWithIdentifier:NEWEVENT sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:DISPLAYEVENT]) {
        PFObject *event = [events objectAtIndex:[eventsTableView indexPathForSelectedRow].row];
        EventProfileViewController *e = [segue destinationViewController];
        e.event = event;
    }
}
@end

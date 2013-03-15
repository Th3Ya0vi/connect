//
//  RequestsViewController.h
//  Connect
//
//  Created by Billy Irwin on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

@interface RequestsViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, ParseManagerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *requestsTableView;
@property (strong, nonatomic) NSMutableArray *friendRequests;
@property (strong, nonatomic) NSMutableArray *eventRequests;
@property (strong, nonatomic) NSMutableArray *groupRequests;
@property (strong, nonatomic) PFObject *requestsBox;
@property (nonatomic) int selectedItemRow;
- (IBAction)acceptFriend:(id)sender;
- (IBAction)rejectFriend:(id)sender;
- (IBAction)acceptEvent:(id)sender;
- (IBAction)rejectEvent:(id)sender;
- (IBAction)acceptGroup:(id)sender;
- (IBAction)rejectGroup:(id)sender;

@end

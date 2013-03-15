//
//  FriendsViewController.h
//  Connect
//
//  Created by Billy Irwin on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

@interface FriendsViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ParseManagerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *friendsTableView;
@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) NSArray *friends;
- (IBAction)sendRequest:(id)sender;
- (IBAction)cancelRequest:(id)sender;

@end

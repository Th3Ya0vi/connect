//
//  FriendViewerViewController.h
//  Connect
//
//  Created by Billy Irwin on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

@interface FriendViewerViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *friendTableView;
@property (strong, nonatomic) NSMutableArray *friends;
@property (strong, nonatomic) NSArray *attending;

- (IBAction)addFriend:(id)sender;

@end

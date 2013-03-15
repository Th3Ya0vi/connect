//
//  GroupsViewController.h
//  Connect
//
//  Created by Billy Irwin on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "PullRefreshTableView.h"

@interface GroupsViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, EGORefreshTableHeaderDelegate, ParseManagerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *groupsTableView;
@property (strong, nonatomic) NSArray *groups;
@property (strong, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic) BOOL reloading;
@end

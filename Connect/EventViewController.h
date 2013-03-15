//
//  EventViewController.h
//  Connect
//
//  Created by Billy Irwin on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

@interface EventViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, ParseManagerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *eventsTableView;
@property (strong, nonatomic) NSArray *events;

@end

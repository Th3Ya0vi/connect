//
//  EventProfileViewController.h
//  Connect
//
//  Created by Billy Irwin on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "FriendPickerViewController.h"
@interface EventProfileViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, FriendPickerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIView *wallpostView;
@property (strong, nonatomic) IBOutlet UITableView *wallpostTableView;
@property (strong, nonatomic) IBOutlet UITextField *wallPostTextField;
@property (strong, nonatomic) PFObject *event;
@property (nonatomic) BOOL doneLoading;
@property (strong, nonatomic) NSMutableArray *wallPosts;
@property (strong, nonatomic) IBOutlet UILabel *attendingLabel;
@property (strong, nonatomic) IBOutlet UILabel *undecidedLabel;

- (IBAction)showUsers:(id)sender;
- (IBAction)displayWallPosts:(id)sender;
- (IBAction)postMessage:(id)sender;
- (IBAction)doneViewPosts:(id)sender;
- (IBAction)attending:(id)sender;
- (IBAction)notAttending:(id)sender;
- (IBAction)inviteFriends:(id)sender;

@end

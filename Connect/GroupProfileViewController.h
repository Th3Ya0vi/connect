//
//  GroupProfileViewController.h
//  Connect
//
//  Created by Billy Irwin on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "FriendPickerViewController.h"
@interface GroupProfileViewController : BaseViewController
<UITableViewDelegate, UITableViewDataSource, FriendPickerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIView *wallpostView;
@property (strong, nonatomic) IBOutlet UITableView *wallpostTableView;
@property (strong, nonatomic) IBOutlet UITextField *wallPostTextField;
@property (strong, nonatomic) PFObject *group;
@property (nonatomic) BOOL doneLoading;
@property (strong, nonatomic) NSMutableArray *wallPosts;
- (IBAction)inviteFriends:(id)sender;

- (IBAction)showUsers:(id)sender;
- (IBAction)displayWallPosts:(id)sender;
- (IBAction)postMessage:(id)sender;
- (IBAction)doneViewPosts:(id)sender;

@end

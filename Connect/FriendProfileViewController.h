//
//  FriendProfileViewController.h
//  Connect
//
//  Created by Billy Irwin on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

@interface FriendProfileViewController : BaseViewController <ParseManagerDelegate>
@property (strong, nonatomic) PFUser *theFriend;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (strong, nonatomic) NSArray *holder;
@property (strong, nonatomic) PFImageView *profilePictureImageView;
- (IBAction)viewFriends:(id)sender;
- (IBAction)viewGroups:(id)sender;
- (IBAction)viewEvents:(id)sender;


@end

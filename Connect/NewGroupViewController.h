//
//  NewGroupViewController.h
//  Connect
//
//  Created by Billy Irwin on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "FriendPickerViewController.h"

@interface NewGroupViewController : BaseViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, FriendPickerDelegate, UITextFieldDelegate, UITextViewDelegate, ParseManagerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UIScrollView *groupScrollView;
@property (strong, nonatomic) NSArray *chosenFriends;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
- (IBAction)inviteFriends:(id)sender;
- (IBAction)createEvent:(id)sender;
- (IBAction)cancelCreateEvent:(id)sender;


@end

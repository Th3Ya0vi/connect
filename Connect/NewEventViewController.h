//
//  NewEventViewController.h
//  Connect
//
//  Created by Billy Irwin on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "FriendPickerViewController.h"

@interface NewEventViewController : BaseViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, FriendPickerDelegate, UITextFieldDelegate, UITextViewDelegate, ParseManagerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UIView *timeChooserView;
@property (strong, nonatomic) IBOutlet UIDatePicker *eventDatePicker;
@property (strong, nonatomic) IBOutlet UIScrollView *eventScrollView;
@property (strong, nonatomic) NSArray *chosenFriends;
@property (strong, nonatomic) NSDate *chosenDate;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
- (IBAction)inviteFriends:(id)sender;
- (IBAction)createEvent:(id)sender;
- (IBAction)cancelCreateEvent:(id)sender;
- (IBAction)chooseDate:(id)sender;
- (IBAction)cancelChooseDate:(id)sender;
- (IBAction)addDate:(id)sender;


@end

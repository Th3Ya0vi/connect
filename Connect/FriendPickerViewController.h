//
//  FriendPickerViewController.h
//  Connect
//
//  Created by Billy Irwin on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol FriendPickerDelegate <NSObject>

- (void)finishedChoosingFriends:(NSArray *)friends withCancelValue:(BOOL)cancel;
@end

@interface FriendPickerViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, ParseManagerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *friendPickerTableView;
@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) NSArray *friends;
@property (strong, nonatomic) IBOutlet UILabel *selectedLabel;
@property (strong, nonatomic) NSArray *previouslySelected;
- (IBAction)finished:(id)sender;
- (IBAction)cancel:(id)sender;

@end

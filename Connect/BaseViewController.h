//
//  BaseViewController.h
//  Connect
//
//  Created by Billy Irwin on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLabel.h"
#import <Parse/Parse.h>
#import "ParseManager.h"
//#import "EGORefreshTableHeaderView.h"
@interface BaseViewController : UIViewController //<EGORefreshTableHeaderDelegate>

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) CLabel *headerLabel;
@property (strong, nonatomic) UIButton *connectButton;
@property (strong, nonatomic) UIView *menuView;
@property (strong, nonatomic) UIButton *homeMenuButton;
@property (strong, nonatomic) UIButton *friendsMenuButton;
@property (strong, nonatomic) UIButton *settingsMenuButton;
@property (strong, nonatomic) UIButton *requestsMenuButton;
@property (strong, nonatomic) UIButton *groupsMenuButton;
@property (strong, nonatomic) UIButton *eventsMenuButton;
@property (strong, nonatomic) UIButton *backButton;
@property (nonatomic) BOOL menuVisible;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) CLabel *backTitle;
@property (strong, nonatomic) NSString *delegateId;
@property (nonatomic) BOOL loading;

- (void)displayAlertforError:(NSError *)error;
- (void)parseManagerFinishedLoading:(NSError *)error forAction:(int)action;
- (void)showBackButton;
- (void)parseManagerFinishedLoadingSingleObject:(PFObject *)object withError:(NSError *)error;
@end

//
//  FriendProfileViewController.m
//  Connect
//
//  Created by Billy Irwin on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendProfileViewController.h"
#import "FriendViewerViewController.h"
#import <Quartzcore/QuartzCore.h>
@interface FriendProfileViewController ()

@end

@implementation FriendProfileViewController
@synthesize usernameLabel;
@synthesize fullNameLabel;
@synthesize theFriend;
@synthesize holder;
@synthesize profilePictureImageView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showBackButton];
    self.backTitle.text = @"Back";
    holder = [NSArray array];
    
    profilePictureImageView = [[PFImageView alloc] initWithFrame:CGRectMake(35, 90, 80, 80)];
    [self.view addSubview:profilePictureImageView];
    profilePictureImageView.file = [theFriend objectForKey:@"profilePicture"];
    [profilePictureImageView loadInBackground];
    
    profilePictureImageView.layer.masksToBounds=NO;
    profilePictureImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    profilePictureImageView.layer.borderWidth = 4;
    profilePictureImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    profilePictureImageView.layer.shadowOpacity = 1;
    profilePictureImageView.layer.shadowOffset = CGSizeMake(3, 3);
    
    [self reloadViews];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setUsernameLabel:nil];
    [self setFullNameLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)finishedFetchingFriends:(NSArray *)objects withError:(NSError *)error
{
    if (!error) {
        holder = objects;
        [self performSegueWithIdentifier:LOADALLFRIENDS sender:self];
    } else {
        [self displayAlertforError:error];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:LOADALLFRIENDS]) {
        FriendViewerViewController *f = [segue destinationViewController];
        f.friends = (NSMutableArray *)holder;
    }
}

- (void)reloadViews
{
    usernameLabel.text = theFriend.username;
    fullNameLabel.text = [NSString stringWithFormat:@"%@ %@", [theFriend objectForKey:FIRSTNAME], [theFriend objectForKey:LASTNAME]];
}

- (IBAction)viewFriends:(id)sender 
{
    [[ParseManager singleton] loadFriendsForUser:theFriend WithCallbackKey:self.delegateId];
}

- (IBAction)viewGroups:(id)sender {
}

- (IBAction)viewEvents:(id)sender {
}
@end

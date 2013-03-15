//
//  HomeViewController.h
//  Connect
//
//  Created by Billy Irwin on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeViewController : BaseViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) PFImageView *profilePictureImageView;
- (IBAction)chooseProfilePicture:(id)sender;
@end

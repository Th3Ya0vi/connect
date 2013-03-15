//
//  HomeViewController.m
//  Connect
//
//  Created by Billy Irwin on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize nameLabel;
@synthesize usernameLabel;
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
    self.title = @"Home";
    self.headerLabel.text = @"Home";
    usernameLabel.text = [PFUser currentUser].username;
    nameLabel.text = [NSString stringWithFormat:@"%@ %@", [[PFUser currentUser] objectForKey:FIRSTNAME], [[PFUser currentUser] objectForKey:LASTNAME]];
    
    profilePictureImageView = [[PFImageView alloc] initWithFrame:CGRectMake(35, 90, 80, 80)];
    [self.view addSubview:profilePictureImageView];
    profilePictureImageView.file = [[PFUser currentUser] objectForKey:@"profilePicture"];
    [profilePictureImageView loadInBackground:^(UIImage *image, NSError *error) {
        if (!error) {
            profilePictureImageView.image = image;
        } else {
            profilePictureImageView.image = [UIImage imageNamed:@"user.png"];
        }
    }];
    
    profilePictureImageView.layer.masksToBounds=NO;
    profilePictureImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    profilePictureImageView.layer.borderWidth = 4;
    profilePictureImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    profilePictureImageView.layer.shadowOpacity = 1;
    profilePictureImageView.layer.shadowOffset = CGSizeMake(3, 3);
    // Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setProfilePictureImageView:nil];
    [self setUsernameLabel:nil];
    [self setNameLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)chooseProfilePicture:(id)sender 
{
    UIActionSheet *picActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose From Existing", @"Take Photo", nil];
    [picActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 2) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        if (buttonIndex == 0) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        } else {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        
    [self presentModalViewController:imagePicker animated:YES];
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *original = [info objectForKey:UIImagePickerControllerOriginalImage];
    CGSize newSize = CGSizeMake(100, 100);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [original drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *small = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImagePNGRepresentation(small);
    PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@.png", [PFUser currentUser].username] data:imageData];
    [imageFile save];
    
    [profilePictureImageView setImage:small];
    
    [[PFUser currentUser] setObject:imageFile forKey:@"profilePicture"];
    [[PFUser currentUser] saveInBackground];
    
    [self dismissModalViewControllerAnimated:YES];
}
@end

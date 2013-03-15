//
//  BaseViewController.m
//  Connect
//
//  Created by Billy Irwin on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize headerView;
@synthesize headerLabel;
@synthesize connectButton;
@synthesize menuView;
@synthesize homeMenuButton, friendsMenuButton, settingsMenuButton, requestsMenuButton, groupsMenuButton, eventsMenuButton;
@synthesize menuVisible;
@synthesize backButton;
@synthesize screenName;
@synthesize backTitle;
@synthesize delegateId;
@synthesize loading;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tabBarController.tabBar setHidden:YES];
    [[self.tabBarController.view.subviews objectAtIndex:0] setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
    self.navigationController.navigationBarHidden = YES;
    
    /*int last = [self.navigationController.viewControllers count]-2;
    NSString *lastTitle = [(UIViewController *)[self.navigationController.viewControllers objectAtIndex:last] title];
    if (lastTitle != NULL) {
        backTitle.text = [NSString stringWithFormat:@"<- %@", lastTitle];
    }*/

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    delegateId = [[NSString alloc] initWithFormat:@"%@", getDelegateId()];
    NSLog(@"delegate id: %@", delegateId);
    [[ParseManager singleton] registerDelegate:self withKey:delegateId];
    
    menuVisible = NO;
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:headerView.frame];
    backgroundImage.image = [UIImage imageNamed:@"black_fade5.png"];
    [headerView addSubview:backgroundImage];
    
    headerLabel = [[CLabel alloc] initWithFrame:CGRectMake(60, 15, 200, 30) andFontSize:25.0];
    headerLabel.textAlignment = UITextAlignmentCenter;
    headerLabel.text = @"Home";
    [headerView addSubview:headerLabel];
    
    connectButton = [[UIButton alloc] initWithFrame:CGRectMake(260, 10, 50, 40)];
    [connectButton addTarget:self action:@selector(displayHideMenu:) forControlEvents:UIControlEventTouchUpInside];
    [connectButton setImage:[UIImage imageNamed:@"c_button2.png"] forState:UIControlStateNormal];
    [headerView addSubview:connectButton]; 
    [headerView bringSubviewToFront:connectButton];
    
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
    backTitle = [[CLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20) andFontSize:20];
    [backButton addSubview:backTitle];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    menuView = [[UIView alloc] initWithFrame:CGRectMake(50, 120, 220, 220)];
    menuView.backgroundColor = [UIColor clearColor];
    menuView.alpha = 0;
    
    UIImageView *menuBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 220, 220)];
    menuBackgroundImage.image = [UIImage imageNamed:@"menu_background.png"];
    menuBackgroundImage.alpha = 0.4;
    [menuView addSubview:menuBackgroundImage];
    
    homeMenuButton = [[UIButton alloc] initWithFrame:CGRectMake(90, 90, 40, 40)];
    homeMenuButton.titleLabel.text = @"Home";
    [homeMenuButton setImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
    homeMenuButton.tag = 1;
    [homeMenuButton addTarget:self action:@selector(changeScreen:) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:homeMenuButton]; 
    
    friendsMenuButton = [[UIButton alloc] initWithFrame:CGRectMake(35, 27, 40, 40)];
    friendsMenuButton.titleLabel.text = @"Friends";
    [friendsMenuButton setImage:[UIImage imageNamed:@"address_book.png"] forState:UIControlStateNormal];
    friendsMenuButton.tag = 2;
    [friendsMenuButton addTarget:self action:@selector(changeScreen:) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:friendsMenuButton]; 
    
    settingsMenuButton = [[UIButton alloc] initWithFrame:CGRectMake(146, 27, 40, 40)];
    settingsMenuButton.titleLabel.text = @"Settings";
    [settingsMenuButton setImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
    settingsMenuButton.tag = 3;
    [settingsMenuButton addTarget:self action:@selector(changeScreen:) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:settingsMenuButton]; 
    
    requestsMenuButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 118, 40, 40)];
    requestsMenuButton.titleLabel.text = @"Requests";
    [requestsMenuButton setImage:[UIImage imageNamed:@"requests.png"] forState:UIControlStateNormal];
    requestsMenuButton.tag = 4;
    [requestsMenuButton addTarget:self action:@selector(changeScreen:) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:requestsMenuButton]; 
    
    groupsMenuButton = [[UIButton alloc] initWithFrame:CGRectMake(167, 118, 40, 40)];
    groupsMenuButton.titleLabel.text = @"Groups";
    [groupsMenuButton setImage:[UIImage imageNamed:@"group.png"] forState:UIControlStateNormal];
    groupsMenuButton.tag = 5;
    [groupsMenuButton addTarget:self action:@selector(changeScreen:) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:groupsMenuButton]; 
    
    eventsMenuButton = [[UIButton alloc] initWithFrame:CGRectMake(90, 173, 40, 40)];
    eventsMenuButton.titleLabel.text = @"Groups";
    [eventsMenuButton setImage:[UIImage imageNamed:@"calendar.png"] forState:UIControlStateNormal];
    eventsMenuButton.tag = 6;
    [eventsMenuButton addTarget:self action:@selector(changeScreen:) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:eventsMenuButton]; 
    
    
    [self.view addSubview:headerView]; 
    [self.view addSubview:menuView];
    
    [self.view sendSubviewToBack:menuView];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"orange_fade.png"]];
    [self.view bringSubviewToFront:headerView];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setHeaderView:nil];
    [super viewDidUnload];
    [[ParseManager singleton] removeDelegate:delegateId];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)displayHideMenu:(id)sender
{
    if (!menuVisible) {
        [self.view bringSubviewToFront:menuView];
        [self animate:nil];
        menuVisible = YES;
    } else {
        [self.view sendSubviewToBack:menuView];
        [self animate:nil];
        menuVisible = NO;
    }
}

- (IBAction)animate:(id)sender {
    
    [UIView animateWithDuration:1.0 animations:^ {
        menuView.alpha = !menuVisible;
        menuView.transform = CGAffineTransformRotate(menuView.transform, M_PI);
        homeMenuButton.transform = CGAffineTransformRotate(homeMenuButton.transform, M_PI);
        friendsMenuButton.transform = CGAffineTransformRotate(friendsMenuButton.transform, M_PI);
        settingsMenuButton.transform = CGAffineTransformRotate(settingsMenuButton.transform, M_PI);
        requestsMenuButton.transform = CGAffineTransformRotate(requestsMenuButton.transform, M_PI);
        groupsMenuButton.transform = CGAffineTransformRotate(groupsMenuButton.transform, M_PI);
        eventsMenuButton.transform = CGAffineTransformRotate(eventsMenuButton.transform, M_PI);
        
        
        /*homeMenuButton.transform = CGAffineTransformTranslate(homeMenuButton.transform, 0.0, -100.0);
        friendsMenuButton.transform = CGAffineTransformTranslate(friendsMenuButton.transform, 0.0, -100.0);
        requestsMenuButton.transform = CGAffineTransformTranslate(requestsMenuButton.transform, 0.0, -100.0);
        settingsMenuButton.transform = CGAffineTransformTranslate(settingsMenuButton.transform, 0.0, -100.0);*/
        
    }
     
        completion:^(BOOL finished) {
            
           /* CAKeyframeAnimation *animation1 = [self createArcAnimationAtStart:3*M_PI/2 Ends:M_PI Distance:5.0];            
            CAKeyframeAnimation *animation2 = [self createArcAnimationAtStart:3*M_PI/2  Ends:2*M_PI/3 Distance:4.0];
            CAKeyframeAnimation *animation3 = [self createArcAnimationAtStart:3*M_PI/2  Ends:M_PI/3 Distance:3.0];
            CAKeyframeAnimation *animation4 = [self createArcAnimationAtStart:3*M_PI/2  Ends:2*M_PI Distance:2.0];
            
                        
            [homeMenuButton.layer addAnimation:animation1 forKey:@"1"];
            [friendsMenuButton.layer addAnimation:animation2 forKey:@"2"];
            [requestsMenuButton.layer addAnimation:animation3 forKey:@"3"];
            [settingsMenuButton.layer addAnimation:animation4 forKey:@"4"];*/
            
          
            
    }];
    
}

- (CAKeyframeAnimation *)createArcAnimationAtStart:(float)start Ends:(float)end Distance:(float)dist
{
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.duration = dist/5.0;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    CGMutablePathRef path = CGPathCreateMutable();
    if (!menuVisible) {
        //pathAnimation.beginTime = CACurrentMediaTime() + 1.0;
        CGPathAddArc(path, NULL, 110, 100, 80, end, start, !menuVisible);
    } else {  
        CGPathAddArc(path, NULL, 110, 100, 80, start, end, !menuVisible);
    }
    
    
    pathAnimation.path = path;
    CGPathRelease(path);
    return pathAnimation;
}

- (IBAction)changeScreen:(UIButton *)sender
{
   
    [self displayHideMenu:nil];
    
    [self.tabBarController setSelectedIndex:sender.tag - 1];
    
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (menuVisible) {
        [self displayHideMenu:nil];
    }
}

- (void)displayAlertforError:(NSError *)error
{
    NSString *errorString = [[error userInfo] objectForKey:@"error"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                    message:errorString
                                                   delegate:self 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil, nil];
    [alert show];

}

- (void)parseManagerFinishedLoading:(NSError *)error forAction:(int)action
{
    //subclasses override this method
}

- (void)parseManagerFinishedLoadingSingleObject:(PFObject *)object withError:(NSError *)error
{
    //subclasses override this method
}

- (void)showBackButton
{
    [self.headerView addSubview:self.backButton];
}


@end

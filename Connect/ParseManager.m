//
//  ParseManager.m
//  Connect
//
//  Created by Billy Irwin on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParseManager.h"
#import <Parse/Parse.h>
#import "Constants.h"
#import "BaseViewController.h"

@implementation ParseManager
@synthesize user;
@synthesize pfFriendsBox;
@synthesize pfGroupsBox;
@synthesize pfEventsBox;
@synthesize pfRequestsBox;
@synthesize delegates;
@synthesize userInfo;


static ParseManager *pm = nil;

+ (ParseManager *)singleton
{
    if (pm == nil) {
        pm = [[ParseManager alloc] init];
    }
    
    return pm;
}

- (NSArray *)friendsBox
{
    
    return [pfFriendsBox objectForKey:FRIENDS];
}

- (NSArray *)friendsBoxNames
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in [pfFriendsBox objectForKey:FRIENDS]) {
        [array addObject:[dict objectForKey:NAME]];
    }
    return array;
}

- (NSArray *)groupsBox
{

    return [pfGroupsBox objectForKey:GROUPS];
}

- (NSArray *)eventsBox
{

    return [pfEventsBox objectForKey:EVENTS];
}

- (NSArray *)friendRequestBox
{
    return [pfRequestsBox objectForKey:FRIENDREQUESTS];
}

- (NSArray *)eventRequestBox
{
    return [pfRequestsBox objectForKey:EVENTREQUESTS];
}

- (NSArray *)groupRequestsBox
{
    return [pfRequestsBox objectForKey:GROUPREQEUSTS];
}

- (id)init
{
    self = [super init];
    if (self) {
        delegates = [[NSMutableDictionary alloc] init];
        userInfo = [[NSDictionary alloc] init];
    }
  
    return self;
}

- (void)updateUser
{
    user = [PFUser currentUser];
    NSLog(@"updating current user to: %@", user.username);
    [user fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        NSString *fbid = [[user objectForKey:BOXIDS] objectForKey:FRIENDS_BOX];
        NSLog(@"friend box id: %@", fbid);
        pfFriendsBox = [PFObject objectWithoutDataWithClassName:FRIENDS_BOX objectId:fbid];
    
        NSString *ebid = [[user objectForKey:BOXIDS] objectForKey:EVENTS_BOX];
        NSLog(@"event box id: %@", ebid);
        pfEventsBox = [PFObject objectWithoutDataWithClassName:EVENTS_BOX objectId:ebid];
    
        NSString *gbid = [[user objectForKey:BOXIDS] objectForKey:GROUPS_BOX];
        NSLog(@"group box id: %@", gbid);
        pfGroupsBox = [PFObject objectWithoutDataWithClassName:GROUPS_BOX objectId:gbid];
    
        NSString *rbid = [[user objectForKey:BOXIDS] objectForKey:REQUESTS_BOX];
        NSLog(@"request box id: %@", rbid);
        pfRequestsBox = [PFObject objectWithoutDataWithClassName:REQUESTS_BOX objectId:rbid];
        
        userInfo = [NSDictionary dictionaryWithObjectsAndKeys:user.username, NAME, rbid, REQUESTBOXID, fbid, FRIENDBOXID,[NSNumber numberWithInt:0], ATTENDING, nil];
    }];
    
}

- (void)registerDelegate:(id)delegate withKey:(NSString *)key
{
    NSLog(@"adding delegate for key: %@",key);
    [delegates setValue:delegate forKey:key];
}

- (void)removeDelegate:(NSString *)key
{
    NSLog(@"removing delegate for key: %@",key);
    [delegates removeObjectForKey:key];
}

- (void)loadUsersForGroupEvent:(PFObject *)object WithCallbackKey:(NSString *)key
{
    [PFObject fetchAllInBackground:[object objectForKey:USERS] block:^(NSArray *objects, NSError *error) {
        [[delegates objectForKey:key] finishedFetchingFriends:objects withError:error];
    }];

}

- (void)loadFriendsForUser:(PFUser *)theUser WithCallbackKey:(NSString *)key
{
    NSString *friendBoxId = [[theUser objectForKey:BOXIDS] objectForKey:FRIENDS_BOX];
    NSLog(@"friendBoxId %@", friendBoxId);
    PFQuery *query = [PFQuery queryWithClassName:FRIENDS_BOX];
    [query getObjectInBackgroundWithId:friendBoxId block: ^(PFObject *object, NSError *error) {
        NSLog(@"got array");
        NSLog(@"%@ count: %i", [object objectForKey:USERNAME], [[object objectForKey:FRIENDS] count]);
        if (!error) {
            [PFObject fetchAllInBackground:[object objectForKey:FRIENDS] block:^(NSArray *objects, NSError *error) {
               [[delegates objectForKey:key] finishedFetchingFriends:objects withError:error];
            }];
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"%@", errorString);
        }
    }];

}

- (void)loadEventsForUser:(PFUser *)theUser WithCallbackKey:(NSString *)key
{
    NSString *eventBoxId = [[theUser objectForKey:BOXIDS] objectForKey:EVENTS_BOX];
    NSLog(@"eventBoxId %@", eventBoxId);
    PFQuery *query = [PFQuery queryWithClassName:EVENTS_BOX];
    [query getObjectInBackgroundWithId:eventBoxId block: ^(PFObject *object, NSError *error) {
        NSLog(@"got array");
        NSLog(@"%@ count: %i", [object objectForKey:USERNAME], [[object objectForKey:EVENTS] count]);
        if (!error) {
            [PFObject fetchAllInBackground:[object objectForKey:EVENTS] block:^(NSArray *objects, NSError *error) {
                [[delegates objectForKey:key] finishedFetchingEvents:objects withError:error];
            }];
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"%@", errorString);
        }
    }];

}

- (void)loadGroupsForUser:(PFUser *)theUser WithCallbackKey:(NSString *)key
{
    NSString *groupBoxId = [[theUser objectForKey:BOXIDS] objectForKey:GROUPS_BOX];
    NSLog(@"groupBoxId %@", groupBoxId);
    PFQuery *query = [PFQuery queryWithClassName:GROUPS_BOX];
    [query getObjectInBackgroundWithId:groupBoxId block: ^(PFObject *object, NSError *error) {
        NSLog(@"got array");
        NSLog(@"%@ count: %i", [object objectForKey:USERNAME], [[object objectForKey:GROUPS] count]);
        if (!error) {
            [PFObject fetchAllInBackground:[object objectForKey:GROUPS] block:^(NSArray *objects, NSError *error) {
                [[delegates objectForKey:key] finishedFetchingGroups:objects withError:error];
            }];
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"%@", errorString);
        }
    }];

}

- (void)loadRequestsForUser:(PFUser *)theUser WithCallbackKey:(NSString *)key
{
    NSString *requestBoxId = [[theUser objectForKey:BOXIDS] objectForKey:REQUESTS_BOX];
    NSLog(@"requestBoxId %@", requestBoxId);
    PFQuery *query = [PFQuery queryWithClassName:REQUESTS_BOX];
    [query getObjectInBackgroundWithId:requestBoxId block: ^(PFObject *object, NSError *error) {
       /* NSLog(@"got array");
        NSLog(@"%@ count: %i", [object objectForKey:USERNAME], [[object objectForKey:REQUESTS] count]);
        if (!error) {
            [PFObject fetchAllInBackground:[object objectForKey:REQUESTS] block:^(NSArray *objects, NSError *error) {
                [[delegates objectForKey:key] finishedFetchingRequests:objects withError:error];
            }];
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"%@", errorString);
        }*/
        
        [[delegates objectForKey:key] finishedFetchingRequests:[object objectForKey:REQUESTS] withError:error];
    }];

}

- (void)acceptFriend:(NSMutableDictionary *)friend withCallbackKey:(NSString *)key
{
    [pfRequestsBox fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [[object objectForKey:REQUESTS] removeObject:friend];
        
        NSString *pfuserName = [PFUser currentUser].className;
    
        PFObject *friendObject = [PFObject objectWithoutDataWithClassName:pfuserName objectId:[friend objectForKey:ID]];
    
        [pfFriendsBox addObject:friendObject forKey:FRIENDS]; 
    
        PFObject *friendBox = [PFObject objectWithoutDataWithClassName:FRIENDS_BOX 
                                                          objectId:[friend objectForKey:FRIENDBOXID]];
    
        [friendBox addObject:[PFUser currentUser] forKey:FRIENDS];   

        [PFObject saveAllInBackground:[NSArray arrayWithObjects:pfRequestsBox, pfFriendsBox, friendBox, nil] block:^ (BOOL success, NSError *error) {        
            [[delegates objectForKey:key] finishedRespondingToRequest:1 withError:error];          
        }];
    }];
}

- (void)rejectFriend:(NSMutableDictionary *)friend withCallbackKey:(NSString *)key
{
    
    [pfRequestsBox fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [[object objectForKey:REQUESTS] removeObject:friend];
        [pfRequestsBox saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
            NSLog(@"success: %i", success);
            [[delegates objectForKey:key] finishedRespondingToRequest:1 withError:error];    
        }];

    }];
}

- (void)acceptEvent:(NSMutableDictionary *)event withCallbackKey:(NSString *)key
{
    [pfRequestsBox fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [[object objectForKey:REQUESTS] removeObject:event];
        [pfRequestsBox saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
            
            PFObject *newEvent = [PFObject objectWithoutDataWithClassName:EVENT objectId:[event objectForKey:ID]];
            [newEvent addObject:[PFUser currentUser] forKey:USERS];
            [pfEventsBox addObject:newEvent forKey:EVENTS];
            
            [PFObject saveAllInBackground:[NSArray arrayWithObjects:pfRequestsBox, pfEventsBox, newEvent, nil] block:^ (BOOL success, NSError *error) {        
                [[delegates objectForKey:key] finishedRespondingToRequest:2 withError:error];    
            }];    
        }];
        
    }];
    
    
}

- (void)rejectEvent:(PFObject *)event withCallbackKey:(NSString *)key
{
    [pfRequestsBox fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [[object objectForKey:REQUESTS] removeObject:event];

        [pfRequestsBox saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
            [[delegates objectForKey:key] finishedRespondingToRequest:2 withError:error];   
        }];
    }];
}

- (void)acceptGroup:(PFObject *)group withCallbackKey:(NSString *)key
{
    [pfRequestsBox fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        PFObject *newGroup = [PFObject objectWithoutDataWithClassName:GROUP objectId:[group objectForKey:ID]];
        [newGroup addObject:[PFUser currentUser] forKey:USERS];
        [pfGroupsBox addObject:newGroup forKey:GROUPS];
        
        [[pfRequestsBox objectForKey:REQUESTS] removeObject:group];
        
        [PFObject saveAllInBackground:[NSArray arrayWithObjects:pfRequestsBox, pfGroupsBox, group, nil] block:^ (BOOL success, NSError *error) {        
            [[delegates objectForKey:key] finishedRespondingToRequest:3 withError:error];         
        }];
    }];
}


- (void)rejectGroup:(PFObject *)group withCallbackKey:(NSString *)key
{
    [pfRequestsBox fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [[pfRequestsBox objectForKey:REQUESTS] removeObject:group];
        [pfRequestsBox saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
            [[delegates objectForKey:key] finishedRespondingToRequest:3 withError:error];    
        }];
    }];
   
}

- (void)sendOutEventRequestsforEvent:(NSMutableDictionary *)event includeSelf:(BOOL)include toFriends:(NSArray *)friends withCallbackKey:(NSString *)key
{
    NSLog(@"starting to send request");
    NSMutableArray *invites = [[NSMutableArray alloc] init];
    
    for (PFUser *friend in friends) {
        PFObject *requestBox = [PFObject objectWithoutDataWithClassName:REQUESTS_BOX objectId:[[friend objectForKey:BOXIDS] objectForKey:REQUESTS_BOX]];
        [requestBox addObject:event forKey:REQUESTS];
        [invites addObject:requestBox];
        [PFPush sendPushMessageToChannelInBackground:friend.username withMessage:@"New Event Request"];
    }
    
    PFObject *newEvent = [PFObject objectWithoutDataWithClassName:EVENT objectId:[event objectForKey:ID]];
    
    if (include) {
        [pfEventsBox addObject:newEvent forKey:EVENTS];
    
        [invites addObject:pfEventsBox];
    }
    
    NSLog(@"starting to save all");
    [PFObject saveAllInBackground:invites block:^ (BOOL success, NSError *error) {
        
        [[delegates objectForKey:key] finishedSendingInvites:error];
    }];
}

- (void)sendOutGroupRequestsforGroup:(PFObject *)group includeSelf:(BOOL)include toFriends:(NSArray *)friends withCallbackKey:(NSString *)key
{
    NSMutableArray *invites = [[NSMutableArray alloc] init];
    
    for (PFUser *friend in friends) {
        PFObject *requestBox = [PFObject objectWithoutDataWithClassName:REQUESTS_BOX objectId:[[friend objectForKey:BOXIDS] objectForKey:REQUESTS_BOX]];
        [requestBox addObject:group forKey:REQUESTS];
        [invites addObject:requestBox];
        [PFPush sendPushMessageToChannelInBackground:friend.username withMessage:@"New Group Request"];
    }
    
    PFObject *newGroup = [PFObject objectWithoutDataWithClassName:GROUP objectId:[group objectForKey:ID]];
    
    if (include) {
        [pfGroupsBox addObject:newGroup forKey:GROUPS];
        
        [invites addObject:pfGroupsBox];
    }
    
    
    [PFObject saveAllInBackground:invites block:^ (BOOL success, NSError *error) {
        
        [[delegates objectForKey:key] finishedSendingInvites:error];
    }];
}


- (void)loadEventProfile:(NSDictionary *)event withCallbackKey:(NSString *)key
{
    PFQuery *query = [PFQuery queryWithClassName:EVENT];
    [query getObjectInBackgroundWithId:[event objectForKey:ID] block:^ (PFObject *loadedEvent, NSError *error) {
        [[delegates objectForKey:key] parseManagerFinishedLoadingSingleObject:loadedEvent withError:error];
    }];
}

- (void)loadGroupProfile:(NSDictionary *)group withCallbackKey:(NSString *)key
{
    PFQuery *query = [PFQuery queryWithClassName:GROUP];
    [query getObjectInBackgroundWithId:[group objectForKey:ID] block:^ (PFObject *loadedGroup, NSError *error) {
        [[delegates objectForKey:key] parseManagerFinishedLoadingSingleObject:loadedGroup withError:error];
    }];
}

- (void)loadUserProfile:(NSDictionary *)theUser withCallbackKey:(NSString *)key
{
    PFQuery *query = [PFUser query];
    [query whereKey:USERNAME equalTo:[theUser objectForKey:NAME]];
    
    [query getFirstObjectInBackgroundWithBlock:^ (PFObject *loadedUser, NSError *error) {
        [[delegates objectForKey:key] parseManagerFinishedLoadingSingleObject:loadedUser withError:error];
    }];
}
@end

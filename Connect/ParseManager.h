//
//  ParseManager.h
//  Connect
//
//  Created by Billy Irwin on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@protocol ParseManagerDelegate <NSObject>
@optional
- (void)finishedFetchingFriends:(NSArray *)objects withError:(NSError *)error;
- (void)finishedFetchingGroups:(NSArray *)objects withError:(NSError *)error;
- (void)finishedFetchingEvents:(NSArray *)objects withError:(NSError *)error;
- (void)finishedFetchingRequests:(NSArray *)objects withError:(NSError *)error;
- (void)finishedRespondingToRequest:(int)type withError:(NSError *)error;
- (void)finishedSendingInvites:(NSError *)error;
@end

@interface ParseManager : NSObject

@property (strong, nonatomic) PFObject *pfFriendsBox;
@property (strong, nonatomic) PFObject *pfEventsBox;
@property (strong, nonatomic) PFObject *pfGroupsBox;
@property (strong, nonatomic) PFObject *pfRequestsBox;
@property (strong, nonatomic) NSMutableDictionary *delegates;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) NSDictionary *userInfo;

+ (ParseManager *)singleton;
- (void)loadUsersForGroupEvent:(PFObject *)object WithCallbackKey:(NSString *)key;
- (void)loadFriendsForUser:(PFUser *)theUser WithCallbackKey:(NSString *)key;
- (void)loadEventsForUser:(PFUser *)theUser WithCallbackKey:(NSString *)key;
- (void)loadGroupsForUser:(PFUser *)theUser WithCallbackKey:(NSString *)key;
- (void)loadRequestsForUser:(PFUser *)theUser WithCallbackKey:(NSString *)key;
- (void)loadEventProfile:(NSDictionary *)event withCallbackKey:(NSString *)key;
- (void)loadGroupProfile:(NSDictionary *)group withCallbackKey:(NSString *)key;
- (void)loadUserProfile:(NSDictionary *)theUser withCallbackKey:(NSString *)key;

- (void)acceptFriend:(NSDictionary *)friendUsername withCallbackKey:(NSString *)key;
- (void)rejectFriend:(NSMutableDictionary *)friendUsername withCallbackKey:(NSString *)key;
- (void)acceptEvent:(NSDictionary *)event withCallbackKey:(NSString *)key;
- (void)rejectEvent:(NSDictionary *)event withCallbackKey:(NSString *)key;
- (void)acceptGroup:(NSDictionary *)group withCallbackKey:(NSString *)key;
- (void)rejectGroup:(NSDictionary *)group withCallbackKey:(NSString *)key;

- (void)registerDelegate:(id)delegate withKey:(NSString *)key;
- (void)removeDelegate:(NSString *)key;


- (NSArray *)friendsBox;
- (NSArray *)groupsBox;
- (NSArray *)eventsBox;
- (NSArray *)friendRequestBox;
- (NSArray *)groupRequestsBox;
- (NSArray *)eventRequestBox;
- (NSArray *)friendsBoxNames;

- (void)updateUser;

- (void)sendOutEventRequestsforEvent:(NSMutableDictionary *)event includeSelf:(BOOL)include toFriends:(NSArray *)friends withCallbackKey:(NSString *)key;
- (void)sendOutGroupRequestsforGroup:(NSMutableDictionary *)group includeSelf:(BOOL)include toFriends:(NSArray *)friends withCallbackKey:(NSString *)key;

@end

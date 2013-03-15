//
//  Constants.h
//  Connect
//
//  Created by Billy Irwin on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Connect_Constants_h
#define Connect_Constants_h

// PFObject Class Names
#define FRIENDS_BOX @"FriendsBox"
#define GROUPS_BOX @"GroupsBox"
#define EVENTS_BOX @"EventsBox"
#define REQUESTS_BOX @"RequestBox"

#define EVENT @"Event"
#define GROUP @"Group"


//---------------------------------------------------------------------------------------------------
//                                       Query Parameters
//---------------------------------------------------------------------------------------------------
// User
#define FIRSTNAME @"firstname"
#define LASTNAME @"lastname"
#define EMAIL @"email"
#define BOXIDS @"boxIds"
#define FRIENDBOXID @"friendBoxId"
#define REQUESTBOXID @"requestBoxId"


// Events and Groups
#define USERS @"users"
#define MESSAGES @"messages"
#define DATE @"date"
#define NAME @"name"
#define DESCRIPTION @"description"
#define SENDER @"sender"
#define CONTENT @"content"
#define CREATOR @"creator"
#define ATTENDING @"attending"
#define ID @"objectId"

// Requests
#define REQUESTS @"requests"
#define FRIENDREQUESTS @"friendRequests"
#define GROUPREQEUSTS @"groupRequests"
#define EVENTREQUESTS @"eventRequests"

//Boxes
#define USERNAME @"username"
#define FRIENDS @"friends"
#define GROUPS @"groups"
#define EVENTS @"events"


//---------------------------------------------------------------------------------------------------
//                                       Segue Identifiers
//---------------------------------------------------------------------------------------------------
#define LOGIN @"login"
#define SIGNUP @"signup"
#define NEWEVENT @"newEvent"
#define CHOOSEFRIENDS @"chooseFriends"
#define DISPLAYEVENT @"displayEvent"
#define CREATEGROUP @"createGroup"
#define LOADGROUP @"loadGroup"
#define LOADEVENTFRIENDS @"loadEventFriends"
#define LOADGROUPFRIENDS @"loadGroupFriends"
#define LOADFRIEND @"loadFriend"
#define LOADALLFRIENDS @"loadAllFriends"
//---------------------------------------------------------------------------------------------------
//                                       Cell Identifiers
//---------------------------------------------------------------------------------------------------
#define FRIENDCELL @"friendCell"
#define EVENTCELL @"eventCell"
#define GROUPCELL @"groupCell"
#define FRIEND_REQUEST_CELL @"friendRequestCell"
#define GROUP_REQUEST_CELL @"groupRequestCell"
#define EVENT_REQUEST_CELL @"eventRequestCell"
#define FRIENDPICKERCELL @"friendPickerCell"
#define WALLPOSTCELL @"wallPostCell"
#define FRIENDVIEWERCELL @"friendViewerCell"

#endif






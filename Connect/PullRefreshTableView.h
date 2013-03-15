//
//  PullRefreshTableView.h
//  Connect
//
//  Created by Billy Irwin on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface PullRefreshTableView : UITableView
@property (strong, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@end

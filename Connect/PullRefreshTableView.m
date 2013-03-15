//
//  PullRefreshTableView.m
//  Connect
//
//  Created by Billy Irwin on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PullRefreshTableView.h"

@implementation PullRefreshTableView
@synthesize refreshHeaderView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 
                                                                                        0.0f - self.bounds.size.height, 
                                                                                        self.frame.size.width, 
                                                                                        self.bounds.size.height)];
        [self addSubview:refreshHeaderView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

//
//  CLabel.m
//  Connect
//
//  Created by Billy Irwin on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CLabel.h"

@implementation CLabel

- (id)initWithFrame:(CGRect)frame andFontSize:(float)size
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont fontWithName:@"Helvetica Neue" size:size];
        self.textColor = [UIColor whiteColor];
        self.shadowColor = [UIColor blackColor];
        self.shadowOffset = CGSizeMake(1.0, 1.0);
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

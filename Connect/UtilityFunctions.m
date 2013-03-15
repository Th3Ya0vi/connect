//
//  UtilityFunctions.m
//  Connect
//
//  Created by Billy Irwin on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UtilityFunctions.h"

NSString *getDelegateId() 
{
    NSMutableString *randomString = [NSMutableString stringWithCapacity: 12];        
    NSString *letters = @"abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ123456789";
    srand(time(NULL));        
    for (int i=0; i<12; i++) {
        [randomString appendFormat: @"%c", [letters characterAtIndex: rand()%[letters length]]];
    }
    
    return (NSString *)randomString;
}

NSNumber *findSelf(NSMutableArray *array, NSString *username)
{
    
    [array indexOfObjectPassingTest:^BOOL(NSDictionary *dict, NSUInteger index, BOOL *stop) {
        if ([[dict objectForKey:NAME] isEqualToString:username]) {
            NSLog(@"removing %@", username);
            [array removeObjectAtIndex:index];
        }
        
        return true;
    }];
    
    return [NSNumber numberWithBool:YES];
}
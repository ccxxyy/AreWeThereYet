//
//  LocationEntityAnnotation.m
//  AreWeThereYet
//
//  Created by Xiaoyi Cai on 14/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationEntityAnnotation.h"

@implementation LocationEntityAnnotation

@synthesize title;
@synthesize subtitle;
@synthesize coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)newCoordinate title:(NSString *)newTitle subtitle:(NSString *)newSubtitle {
    
    
    
    if ((self = [super init])) {
        
        title = [newTitle copy];
        
        subtitle = [newSubtitle copy];
        
        coordinate = newCoordinate;
        
    }
    
    return self;
    
}



- (void)dealloc

{
    
    [title release];
    
    [subtitle release];
    
    [super dealloc];
    
}



@end

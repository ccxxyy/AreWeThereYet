//
//  LocationEntityAnnotation.h
//  AreWeThereYet
//
//  Created by Xiaoyi Cai on 14/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface LocationEntityAnnotation : NSObject<MKAnnotation>{
    
    NSString *title;
    
    NSString *subtitle;
    
    CLLocationCoordinate2D coordinate;
    
}



@property (nonatomic, readonly, copy) NSString *title;

@property (nonatomic, readonly, copy) NSString *subtitle;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;



- (id)initWithCoordinate:(CLLocationCoordinate2D)newCoordinate title:(NSString *)newTitle subtitle:(NSString *)newSubtitle;



@end

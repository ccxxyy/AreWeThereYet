//
//  ListView.h
//  AreWeThereYet
//
//  Created by Xiaoyi Cai on 13/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#define METERS_PER_MILE 1609.344


@interface ListView : UITableViewController <CLLocationManagerDelegate>{
    // the same thing with map view
    NSManagedObjectContext *managedObjectContext;
    NSMutableArray *myEntityArray;
    MKMapView *mapView;
    CLLocationManager *locationManager;

}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *myEntityArray;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) CLLocationManager *locationManager;
//- (void) updateProximityWithNewLocation:(CLLocation *)newLocation;

@end

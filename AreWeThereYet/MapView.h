//
//  MapView.h
//  AreWeThereYet
//
//  Created by Xiaoyi Cai on 13/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#define METERS_PER_MILE 1609.344

@interface MapView : UIViewController<CLLocationManagerDelegate>{
    // define managed object context
    NSManagedObjectContext *managedObjectContext;
    // define a mapview
    MKMapView *mapView;
    // define a location manager
    CLLocationManager *locationManager;
    // define an array to store the information from the data center
    NSArray *array1;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSArray *array1;

@end

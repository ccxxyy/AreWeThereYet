//
//  MapView.m
//  AreWeThereYet
//
//  Created by Xiaoyi Cai on 13/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MapView.h"
#import "LocationEntityAnnotation.h"
#import "Entity.h"


@implementation MapView

@synthesize managedObjectContext;
@synthesize mapView;
@synthesize locationManager;
@synthesize array1;


- (void) updateProximityWithNewLocation:(CLLocation *)newLocation {
    
    
    
    // Assumes that data has already been loaded into myLocationEntityArray
    
    if (array1 == nil) {
        
        return;
        
    }
    
    
    // Iterate through, to update proximity and find nearest object.
    
    
    
    Entity *myloc;
    
    
    
    CLLocationDistance proximity;
    
    for (myloc in array1) {
        
        CLLocation *loc = [[[CLLocation alloc] initWithLatitude:[[myloc laititude] doubleValue]
                            
                                                      longitude:[[myloc longititude] doubleValue]] autorelease];
        
        
        
        proximity = [loc distanceFromLocation:newLocation];
       // NSLog(@"proximity...... %f",proximity);
        // set the new proximity
        [myloc setProximity:[NSNumber numberWithDouble:proximity]];
        
    }
    
    NSError *error = nil;
    
    [managedObjectContext save:&error];
    
}




// ================================================================================================

#pragma mark - Core Location Delegate Methods

- (CLLocationManager *)locationManager {
    
    if (locationManager != nil) {
        
        return locationManager;
        
    }
    
    locationManager = [[CLLocationManager alloc] init];
    
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    
    [locationManager setDistanceFilter:30];
    
    [locationManager setDelegate:self];
    
    return locationManager;
    
}

// ================================================================================================

#pragma mark - Core Location Delegate Methods



- (void) locationManager:(CLLocationManager *)manager

     didUpdateToLocation:(CLLocation *)newLocation

            fromLocation:(CLLocation *)oldLocation {

    
    NSLog(@"NearestLocationViewController new location: latitude %+.6f, longitude %+.6f\n",
          
          [newLocation coordinate].latitude,
          
          [newLocation coordinate].longitude);    
    
    // set the view region
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance([newLocation coordinate],
                                                                       
                                                                       METERS_PER_MILE, METERS_PER_MILE);
    
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];    
    
    // use the update method to get the new proximity
    [self updateProximityWithNewLocation:newLocation];
    
    // ====================================================================
    
    // Get data from Core Data - 1) Define the Fetch Request
    
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyLocationEntity"
                                   
                                              inManagedObjectContext:managedObjectContext];
    
    [request setEntity:entity];
    
    // ====================================================================
    
    // Get data from Core Data - 2) Set the Sort Descriptor
    
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"proximity" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [request setSortDescriptors:sortDescriptors];
    
    [sortDescriptors release];
    
    [sortDescriptor release];
    
    // ====================================================================
    
    // Get data from Core Data - 3) Execute the Request
    
    
    
    NSError *error = nil;
    
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    //NSLog(@"fethch is %@",mutableFetchResults);
    
    if (mutableFetchResults == nil) {
        
        // Need to handle the error
        
        NSLog(@"Error when fetching data from Core Data");
        
    }
    // ====================================================================
    
    // Cleaning up...
    
    
    // set the fetch result to array1
    [self setArray1:mutableFetchResults];
    //NSLog(@"array1 is %@", array1);
    
    // Clear pins
    
    for (id<MKAnnotation> annotation in
         
         [mapView annotations]) {
        
        [mapView removeAnnotation:annotation];
        
    }
    
    // find the closest 10 shop and add annotation
    
    for (int j=0; j<10; j++) {
        
        
        Entity *en1 = [array1 objectAtIndex:j];
        
        //NSLog(@"array count is %@" ,en1);
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[en1 laititude] doubleValue], [[en1 longititude] doubleValue]);
        
        
        LocationEntityAnnotation *annotation = [[[LocationEntityAnnotation alloc]
                                                 
                                                 initWithCoordinate: coordinate
                                                 
                                                 title:[en1 name]
                                                 
                                                 subtitle:[en1 comment]] autorelease];    
        
        [mapView addAnnotation:annotation];
        
    }


    [mapView setRegion:adjustedRegion animated:YES];
    
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    // For now, do nothing other than report to the log
    
    NSLog(@"Unable to get location events");
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
            [self setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Map" image:[UIImage imageNamed:@"103-map.png"] tag:0]];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    // read the context of the plist file
    NSBundle *bundle= [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"CityCycleRideLocations" ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistPath];
    //NSLog(@"plist array is %@", array);    
    // set the information from plist file to data center
    for (int i=0; i<[array count]; i++) {
        
        NSDictionary *single = [array objectAtIndex:i];
        Entity *newLocationEntity = (Entity *)[NSEntityDescription
                                               
                                               insertNewObjectForEntityForName:@"MyLocationEntity"
                                               
                                               inManagedObjectContext:managedObjectContext];
        // set the entity
        [newLocationEntity setName:[single objectForKey:@"name"]];
        [newLocationEntity setComment:[single objectForKey:@"comments"]];
        [newLocationEntity setLaititude:[single objectForKey:@"latitude"]];
        [newLocationEntity setLongititude:[single objectForKey:@"longitude"]];
        
        // Save the new event
        
        NSError *error = nil;
        
        if (![managedObjectContext save:&error]) {
            
            // We should handle the error
            
            NSLog(@"Error in saving an event in addLocation");
            
        }
        
    }
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated

{
    
    [super viewWillAppear:animated];
    
    NSLog(@"NearestLocationViewController about to appear");
    
    [[self locationManager] startUpdatingLocation];
    
}



- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    NSLog(@"NearestLocationViewController about to disappear");
    
    [[self locationManager] stopUpdatingLocation];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

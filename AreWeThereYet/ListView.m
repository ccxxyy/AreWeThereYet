//
//  ListView.m
//  AreWeThereYet
//
//  Created by Xiaoyi Cai on 13/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ListView.h"
#import "Entity.h"


@implementation ListView

@synthesize managedObjectContext;
@synthesize myEntityArray;
@synthesize locationManager;
@synthesize mapView;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
            [self setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Locations" image:[UIImage imageNamed:@"74-location.png"] tag:1]];
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
    [self setTitle:@"Locations"];
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    // invoke locationManager method to update the data
    [[self locationManager] startUpdatingLocation];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // invoke locationManager method to update the data
    [[self locationManager] startUpdatingLocation];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // to stop the updating
    [[self locationManager] stopUpdatingLocation];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    Entity *myloc = (Entity *)[myEntityArray objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:[myloc name]];
    
    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%.3f meters",[[myloc proximity] doubleValue]]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}



- (void) updateProximityWithNewLocation:(CLLocation *)newLocation {
    
    
    
    // Assumes that data has already been loaded into myLocationEntityArray
    
    if (myEntityArray == nil) {
        
        return;
        
    }
    
    
    // Iterate through, to update proximity and find nearest object.
    
    
    
    Entity *myloc;
    
    
    
    CLLocationDistance proximity;
    
    for (myloc in myEntityArray) {
        
        CLLocation *loc = [[[CLLocation alloc] initWithLatitude:[[myloc laititude] doubleValue]
                            
                                                      longitude:[[myloc longititude] doubleValue]] autorelease];
        
        
        
        proximity = [loc distanceFromLocation:newLocation];
        // NSLog(@"proximity...... %f",proximity);
        
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
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance([newLocation coordinate],
                                                                       
                                                                       METERS_PER_MILE, METERS_PER_MILE);
    
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];    
    
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
    NSLog(@"fethch is %@",mutableFetchResults);
    
    if (mutableFetchResults == nil) {
        
        // Need to handle the error
        
        NSLog(@"Error when fetching data from Core Data");
        
    }
    // ====================================================================
    
    
    [self setMyEntityArray:mutableFetchResults];
    // reload the table view
    [[self tableView] reloadData];

    
    [mapView setRegion:adjustedRegion animated:YES];
    
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    // For now, do nothing other than report to the log
    
    NSLog(@"Unable to get location events");
    
}


@end

//
//  TripRecorder.m
//  DriveSense_iOS
//
//  Created by Mickey Barboi on 2/23/14.
//  Copyright (c) 2014 Mickey Barboi. All rights reserved.
//

#import "TripRecorder.h"
#import "AppDelegate.h"
#import "Trip.h"
#import "GPSCoordinate.h"

@interface TripRecorder () {
    BOOL recording;
    CLLocationManager *locationManager;
    
    //used to remember what the last reported coordinate was so we can accurately
    //close out a trip. See stopRecording method
    CLLocation *lastReceivedLocation;
    
    NSManagedObjectContext *context;
    
    Trip *currentTrip;
}
@end

@implementation TripRecorder


+ (id)recorder {
    static TripRecorder *recorder = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        recorder = [[self alloc] init];
    });
    return recorder;
}

- (id)init {
    if (self = [super init]) {
        recording = NO;
        locationManager = [[CLLocationManager alloc] init];
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 1; // meters
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        context = [appDelegate managedObjectContext];
    }
    return self;
}


#pragma mark Recording Methods
- (BOOL) startRecording {
    //start collecting data
    [locationManager startUpdatingLocation];
    
    currentTrip = [NSEntityDescription insertNewObjectForEntityForName:@"Trip" inManagedObjectContext:context];
    
    currentTrip.date = [NSDate date];
    currentTrip.name = @"name";
    
    [self saveChanges];
    
    return YES;
}

- (BOOL) stopRecording {
    //stop collecting data. Ensure that this is a valid time to do this
    [locationManager stopUpdatingLocation];
    
    GPSCoordinate *coord = [NSEntityDescription insertNewObjectForEntityForName:@"GPSCoordinate" inManagedObjectContext:context];
    coord.lat = [NSNumber numberWithDouble:lastReceivedLocation.coordinate.latitude];
    coord.lon = [NSNumber numberWithDouble:lastReceivedLocation.coordinate.longitude];
    
    [currentTrip setEndCoordinate:coord];
    
    [self saveChanges];
    currentTrip = nil;
    
    return YES;
}


#pragma mark CoreLocation
- (NSArray *) getTrips {
    NSLog(@"Shared Model: fetching trips... ");
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Trip" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest, return array
    return [context executeFetchRequest:fetchRequest error:&error];
}

- (void) saveChanges {
    //wrapper method for any saves that occur
    NSError *error;
    
    if (![context save:&error])
        NSLog(@"SharedModel: ERROR saving trip: %@", [error localizedDescription]);
}

#pragma mark CLLocation Callback
// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    lastReceivedLocation = [locations objectAtIndex:0];
    
    GPSCoordinate *coord = [NSEntityDescription insertNewObjectForEntityForName:@"GPSCoordinate" inManagedObjectContext:context];
    coord.lat = [NSNumber numberWithDouble:lastReceivedLocation.coordinate.latitude];
    coord.lon = [NSNumber numberWithDouble:lastReceivedLocation.coordinate.longitude];
    coord.timestamp = [NSDate date];
    
    if(currentTrip.startCoordinate == nil)
        currentTrip.startCoordinate = coord;
    
    [currentTrip addCoordinatesObject:coord];
    
    [self saveChanges];
    
    //NSLog(@"%f, %f", lastReceivedLocation.coordinate.longitude, lastReceivedLocation.coordinate.latitude);

}
@end

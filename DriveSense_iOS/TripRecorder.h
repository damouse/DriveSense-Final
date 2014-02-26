//
//  TripRecorder.h
//  DriveSense_iOS
//
//  Created by Mickey Barboi on 2/23/14.
//  Copyright (c) 2014 Mickey Barboi. All rights reserved.
//

/**
 Class is a recorder wrapper that takes care of all the implementation details of recording 
 trips, including starting a new trip, ending a trip, recording trip information (gps, accel, 
 etc) and storing it all within the database by interfacing with SharedModel.
 
 This class does not read the data back from the database or otherwise parse it in any way. 
 
 This class is a singleton, as it must stay running no matter the active controller, and must 
 provide an interface to all running controllers should an issue arise (like the app crashing, 
 going to background, etc etc)
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface TripRecorder : NSObject <CLLocationManagerDelegate>

//begins recording a new trip. Returns true if the recording started,
//false if there is a currently running trip or leftovers from an old session
- (BOOL) startRecording;

//same as above, returns true if the trip was successfully saved to database,
//false if that was impossible for whatever reason
- (BOOL) stopRecording;

//singleton method
+ (id)recorder;


- (NSArray *) getTrips;
@end

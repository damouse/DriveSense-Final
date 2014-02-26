//
//  MapRootViewController.h
//  DriveSense_iOS
//
//  Created by Mickey Barboi on 2/23/14.
//  Copyright (c) 2014 Mickey Barboi. All rights reserved.
//

/**
 Controller runs the map, updates location, and offers buttons to the other controllers in the project.
 
 When trips are displayed here, a view slides-in showing the trips as well as their locations on the map. The map
 animates up at that time.
 
 TripRecorder actually does the recording.
 
 SharedModel saves trip information to the databse store.
 */

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapRootViewController : UIViewController {
    
    __weak IBOutlet MKMapView *mapMain;
    __weak IBOutlet UIButton *buttonRecord;
    
    //the view that animates in from the bottom
    __weak IBOutlet UIView *viewRecordingContainer;
    
    //the two labels in the slidein view that we change when a new trip starts
    __weak IBOutlet UILabel *labelTripName;
    __weak IBOutlet UILabel *labelDuration;
}

- (IBAction)record:(id)sender;
- (IBAction)showTrips:(id)sender;

@end

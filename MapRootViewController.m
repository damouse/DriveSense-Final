//
//  MapRootViewController.m
//  DriveSense_iOS
//
//  Created by Mickey Barboi on 2/23/14.
//  Copyright (c) 2014 Mickey Barboi. All rights reserved.
//

#import "MapRootViewController.h"
#import "AppDelegate.h"
#import "TripRecorder.h"
#import "MapAnnotation.h"
#import "Trip.h"
#import "GPSCoordinate.h"

@interface MapRootViewController () {
    
    //a flag to indicate the controller is currently recording
    BOOL recording;
    
    //used to save the final position of the view on the screen so we can animate to here later
    CGRect frameIn;
    
    //a counter to represent the total elapsed time
    int secondsRecording;
    
    //A timer. It calls the given method ever x seconds
    NSTimer *durationTimer;
}

@end


@implementation MapRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //init recording to NO as a default
    recording = NO;
    [mapMain setDelegate:self];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [labelTripName setText:@"Name Placeholder"];
    
    [mapMain setUserTrackingMode:MKUserTrackingModeFollow];
    
    frameIn = viewRecordingContainer.frame;
    [self animateViewOut];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Buttons
- (IBAction)record:(id)sender {
    //if currently recording, pause. Toggles image currently displayed from play button to pause button
    
    //switch images
    if(recording) {
        [buttonRecord setBackgroundImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
        
        //start the timer
        durationTimer = nil;
        
        //don't follow the user around when not tracking
        [mapMain setUserTrackingMode:MKUserTrackingModeNone];
        
        [[TripRecorder recorder] stopRecording];
        [self animateViewOut];
    }
    else {
        [buttonRecord setBackgroundImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateNormal];
        
        //follow the user along when tracking
        [mapMain setUserTrackingMode:MKUserTrackingModeFollow];
        
        //stop the timer
        
        durationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(incrementTimer) userInfo:nil repeats:YES];
        
        [[TripRecorder recorder] startRecording];
        [self animateViewIn];
    }
    
    //toggle flag
    recording = !recording;
}

- (IBAction)showTrips:(id)sender {
    NSArray *trips = [[TripRecorder recorder] getTrips];
    
    for(Trip *trip in trips) {
        [self drawRouteForCoordinates:[trip coordinates]];
        [self dropPinForCoordinate:[trip startCoordinate]];
        [self dropPinForCoordinate:[trip endCoordinate]];
    }
}


#pragma mark Trip Timing
- (void) incrementTimer {
    secondsRecording++;
    
    [labelDuration setText:[NSString stringWithFormat:@"%i seconds", secondsRecording]];
}


#pragma mark Animation Methods
- (void) animateViewIn {
    [UIView animateWithDuration:0.25 animations:^{
        viewRecordingContainer.frame =  frameIn;
    }];
}

- (void) animateViewOut {
    [UIView animateWithDuration:0.25 animations:^{
        int y = self.view.frame.size.height;
        
        CGRect newFrame = frameIn;
        newFrame.origin.y = y;
        
        viewRecordingContainer.frame =  newFrame;
    }];
}


#pragma mark Map Drawing
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    //check to make sure its a polyline (this method is called for anything else thats drawn on a map)
    if (![overlay isKindOfClass:[MKPolygon class]]) {
        MKPolyline *route = overlay;
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        renderer.strokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
        renderer.lineWidth = 3.0;
        return renderer;
    } else {
        return nil;
    }
}

- (void) drawRouteForCoordinates:(NSOrderedSet *) points{
    //draw the route for the map based on the coordiantes
    MKMapPoint* pointArray = malloc(sizeof(CLLocationCoordinate2D) * [points count]);
    
    //extract the CLLocation2D objects, add them all to a point in the reference frame of the map
    //note the array is a C array
    for(int i = 0; i < [points count]; i++) {
        GPSCoordinate *coordinate = [points objectAtIndex:i];
        
        double lat = [coordinate.lat doubleValue];
        double lon = [coordinate.lon doubleValue];
        
        MKMapPoint point = MKMapPointForCoordinate(CLLocationCoordinate2DMake(lat, lon));
        pointArray[i] = point;
    }
    
    // create the polyline based on the array of points, add to map
    [mapMain addOverlay:[MKPolyline polylineWithPoints:pointArray count:[points count]]];
    free(pointArray);
}

- (void) dropPinForCoordinate:(GPSCoordinate *) coordinate {
    MapAnnotation *annotation = [[MapAnnotation alloc]init];
    
    double lat = [coordinate.lat doubleValue];
    double lon = [coordinate.lon doubleValue];
    
    CLLocationCoordinate2D coordinate2D= CLLocationCoordinate2DMake(lat, lon);
    
    annotation.coordinate = coordinate2D;
    annotation.subtitle = @"Subtitle";
    annotation.title = @"Title";
    
    [mapMain addAnnotation:annotation];
}
@end

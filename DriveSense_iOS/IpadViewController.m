//
//  IpadViewController.m
//  DriveSense_iOS
//
//  Created by Mickey Barboi on 2/27/14.
//  Copyright (c) 2014 Mickey Barboi. All rights reserved.
//

#import "IpadViewController.h"
#import "MapRootViewController.h"
#import "TripsViewController.h"

@interface IpadViewController () {
    MapRootViewController *mapVC;
    UINavigationController *nav;
}

@end

@implementation IpadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
    TripsViewController *table = [storyboard instantiateViewControllerWithIdentifier:@"table"];
    
    [self addChildViewController:table];
    [table didMoveToParentViewController:self];
    [containerLeft addSubview:table.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"embed"]) {
        mapVC = (MapRootViewController *) [segue destinationViewController];
    }
    else if([segue.identifier isEqualToString: @"nav"]) {
        nav = (UINavigationController *) [segue destinationViewController];
    }
}

- (IBAction)record:(id)sender {
    [mapVC record:nil];
}

- (IBAction)trips:(id)sender {
    [mapVC showTrips:nil];
}

- (IBAction)settings:(id)sender {
    [mapVC settings:nil];
}
@end

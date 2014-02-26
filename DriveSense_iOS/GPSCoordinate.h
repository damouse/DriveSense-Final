//
//  GPSCoordinate.h
//  DriveSense_iOS
//
//  Created by Mickey Barboi on 2/25/14.
//  Copyright (c) 2014 Mickey Barboi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GPSCoordinate : NSManagedObject

@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSDate * timestamp;

@end

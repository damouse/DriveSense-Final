//
//  Trip.h
//  DriveSense_iOS
//
//  Created by Mickey Barboi on 2/25/14.
//  Copyright (c) 2014 Mickey Barboi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPSCoordinate;

@interface Trip : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSOrderedSet *coordinates;
@property (nonatomic, retain) GPSCoordinate *endCoordinate;
@property (nonatomic, retain) GPSCoordinate *startCoordinate;
@end

@interface Trip (CoreDataGeneratedAccessors)

- (void)insertObject:(GPSCoordinate *)value inCoordinatesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCoordinatesAtIndex:(NSUInteger)idx;
- (void)insertCoordinates:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCoordinatesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCoordinatesAtIndex:(NSUInteger)idx withObject:(GPSCoordinate *)value;
- (void)replaceCoordinatesAtIndexes:(NSIndexSet *)indexes withCoordinates:(NSArray *)values;
- (void)addCoordinatesObject:(GPSCoordinate *)value;
- (void)removeCoordinatesObject:(GPSCoordinate *)value;
- (void)addCoordinates:(NSOrderedSet *)values;
- (void)removeCoordinates:(NSOrderedSet *)values;
@end

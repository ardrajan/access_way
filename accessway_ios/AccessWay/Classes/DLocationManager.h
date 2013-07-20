//
//  DLocationManager.h
//  Dash
//
//  Created by Robin Chou on 6/7/13.
//  Copyright (c) 2013 Dash Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^LocationUpdateBlock)(CLLocationManager *manager, NSArray *locations);
typedef void(^LocationFailBlock)(CLLocationManager *manager, NSError *error);

@interface DLocationManager : NSObject

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (assign, nonatomic) CGFloat defaultTimeout;

+ (DLocationManager *)sharedManager;

/**
 *  Update user location once with blocks
 */
- (void)retrieveUserLocationSuccess:(LocationUpdateBlock)success failure:(LocationFailBlock)failure;

/**
 *  Start updating the user's location
 */
- (void)startUpdatingLocation;

/**
 *  Stop updating the user's location
 */
- (void)stopUpdatingLocation;

@end

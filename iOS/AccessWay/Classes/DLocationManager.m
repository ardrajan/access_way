//
//  DLocationManager.m
//  Dash
//
//  Created by Robin Chou on 6/7/13.
//  Copyright (c) 2013 Dash Software. All rights reserved.
//

#import "DLocationManager.h"

#define kDefaultTimeout 3.0

@interface DLocationManager() <CLLocationManagerDelegate>

@property (nonatomic, strong) NSTimer *queryingTimer;
@property (copy) LocationUpdateBlock success;
@property (copy) LocationFailBlock failure;

@end

@implementation DLocationManager

+ (DLocationManager *)sharedManager {
    static dispatch_once_t once;
    static DLocationManager *sharedManager;
    dispatch_once(&once, ^ {
        sharedManager = [[DLocationManager alloc] init];
    });
    return sharedManager;
}

#pragma mark - Init

- (id)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.defaultTimeout = kDefaultTimeout;
        self.locationManager.delegate = self;
    }
    return self;
}

#pragma mark - Instance Methods

- (void)retrieveUserLocationSuccess:(LocationUpdateBlock)success failure:(LocationFailBlock)failure
{
    self.success = success;
    self.failure = failure;
    [self startUpdatingLocation];
}

- (void)startUpdatingLocation
{
    if (![CLLocationManager locationServicesEnabled]) {
        if (self.failure) {
            self.failure(self.locationManager, [NSError errorWithDomain:NSLocalizedString(@"Location Services Disabled", nil) code:0 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Dash requires location services to find and pay at nearby businesses.", nil)}]);
        }
        return;
    }
    
    [self.locationManager startUpdatingLocation];
    
    // Check if the user authorized app to use location services
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [self startQueryingTimer];
    }
}

- (void)stopUpdatingLocation
{
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // If it's a relatively recent event, turn off updates to save power
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) > 15.0)
        return;
    
    self.location = [locations objectAtIndex:0];

    if (self.location.horizontalAccuracy <= self.locationManager.desiredAccuracy) {
        [self stopUpdatingLocation];
        [self stopQueryingTimer];
        if (self.success) {
            self.success(manager, locations);
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self stopUpdatingLocation];
    if (self.failure) {
        self.failure(manager, error);
    }
    self.success = nil;
    self.failure = nil;
}

#pragma mark - Query Timer

-(void)startQueryingTimer
{
    [self stopQueryingTimer];
    self.queryingTimer = [NSTimer scheduledTimerWithTimeInterval:_defaultTimeout target:self selector:@selector(queryingTimerPassed) userInfo:nil repeats:YES];
}

-(void)stopQueryingTimer
{
    if (self.queryingTimer) {
        [self.queryingTimer invalidate];
        _queryingTimer = nil;
    }
}

-(void)queryingTimerPassed
{
    [self stopQueryingTimer];
    [self stopUpdatingLocation];
    
    if (self.success && self.location) {
        self.success(self.locationManager, @[self.location]);
    }
    if (self.failure && !self.location) {
        self.failure(self.locationManager, [NSError errorWithDomain:NSLocalizedString(@"Location Error", nil) code:0 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"We tried detecting your location but something went wrong. Please try again.", nil)}]);
    }
}

@end

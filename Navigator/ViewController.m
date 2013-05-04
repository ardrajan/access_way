//
//  ViewController.m
//  Navigator
//
//  Created by Robin Chou on 5/4/13.
//  Copyright (c) 2013 Robin Chou. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AFNetworking/AFNetworking.h>
#import "StopData.h"

@interface ViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) NSArray *transitStopsArray;
@property (strong, nonatomic) NSMutableDictionary *transitStops;
@property (strong, nonatomic) NSDictionary *userLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ViewController 

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"http://www.mocky.io/v2/51855c65f3752bc301b62bbd"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.transitStopsArray = [JSON objectForKey:@"nearby_stops"];
        for (NSDictionary *stop in self.transitStopsArray) {
            // create StopData and store it in transitStops
            StopData *stopData = [[StopData alloc] init];
            stopData.stopID = [stop objectForKey:@"id"];
            stopData.lat = [stop objectForKey:@"lat"];
            stopData.lng = [stop objectForKey:@"lng"];
            stopData.data = stop;
            [self.transitStops setObject:stopData forKey:[stop objectForKey:@"id"]];
        }
    } failure:nil];
    [operation start];
    
    [self startLocationUpdate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    _userLocation = nil;
    _transitStops = nil;
    _locationManager = nil;
}

#pragma mark - Custom Actions

- (void)startLocationUpdate
{
    if (nil == _locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
}

#pragma mark - Location Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // If it's a relatively recent event, turn off updates to save power
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        // NSLog(@"latitude %+.6f, longitude %+.6f\n",
        // location.coordinate.latitude,
        // location.coordinate.longitude);
        // find nearest stop
        NSDictionary *closestStop;
        for (int i=0; i < self.transitStopsArray.count; i++) {
            NSDictionary *stop = [self.transitStopsArray objectAtIndex:i];
            CLLocation *poiLoc = [[CLLocation alloc] initWithLatitude:[[stop objectForKey:@"lat"] doubleValue] longitude:[[stop objectForKey:@"lng"] doubleValue]];
            CLLocationDistance currentDistance = [location distanceFromLocation:poiLoc];
            if (currentDistance < 20.0) {
                closestStop = stop;
                break;
            }
            NSLog(@"%f", currentDistance);
        }
        NSLog(@"%@", closestStop);
    }
}

@end
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
#import "DetailViewController.h"

@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) NSArray *transitStops;
@property (strong, nonatomic) NSDictionary *userLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL isLocated;
@property (strong, nonatomic) NSDictionary *stop;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isLocated = NO;
    [self startLocationUpdate];
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    _userLocation = nil;
    _transitStops = nil;
    _locationManager = nil;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"presentDetailView"]) {
        UINavigationController *nc = (UINavigationController *)segue.destinationViewController;
        DetailViewController *vc = (DetailViewController *)nc.topViewController;
        vc.stop = _stop;
    }
}

-(void)centerOnUser
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.020;
    span.longitudeDelta = 0.020;
    
    CLLocationCoordinate2D location;
    location.latitude = [[self.userLocation objectForKey:@"lat"] doubleValue];
    location.longitude = [[self.userLocation objectForKey:@"lng"] doubleValue];
    region.span = span;
    region.center = location;
    
    [self.mapView setRegion:region animated:YES];
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

-(void)findNearbyWithLatitude:(NSString *)lat longitude:(NSString *)lng
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://3twg.localtunnel.com/api/StopsNearby/%@/%@/0.25", lat, lng]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        self.transitStops = JSON;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    }];
    [operation start];
}

- (IBAction)locateStop:(id)sender {
    [self startLocationUpdate];
}

- (IBAction)popViewController:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

-(void)openStopDetailView:(NSDictionary *)stop
{
    _stop = stop;
    [self performSegueWithIdentifier:@"presentDetailView" sender:self];
}

#pragma mark - Location Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // If it's a relatively recent event, turn off updates to save power
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        if (!_isLocated) {
            _isLocated = YES;
            [self findNearbyWithLatitude:[NSString stringWithFormat:@"%0.7f", location.coordinate.latitude] longitude:[NSString stringWithFormat:@"%0.7f", location.coordinate.longitude]];
        } else {
            NSDictionary *closestStop;
            for (int i=0; i < self.transitStops.count; i++) {
                NSDictionary *stop = [self.transitStops objectAtIndex:i];
                CLLocation *poiLoc = [[CLLocation alloc] initWithLatitude:[[stop objectForKey:@"stop_lat"] doubleValue] longitude:[[stop objectForKey:@"stop_lon"] doubleValue]];
                CLLocationDistance currentDistance = [location distanceFromLocation:poiLoc];
                if (currentDistance < 800.0) {
                    closestStop = stop;
                    [self openStopDetailView:stop];
                    [_locationManager stopUpdatingLocation];
                    _isLocated = NO;
                    break;
                } else {
                    closestStop = nil;
                }
                NSLog(@"%f", currentDistance);
            }
        }
    }
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    self.userLocation = @{@"lat":[NSNumber numberWithDouble:aUserLocation.coordinate.latitude], @"lng":[NSNumber numberWithDouble:aUserLocation.coordinate.longitude]};
    [self centerOnUser];
}

@end
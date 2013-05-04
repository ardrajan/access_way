//
//  ViewController.m
//  Navigator
//
//  Created by Robin Chou on 5/4/13.
//  Copyright (c) 2013 Robin Chou. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController () <MKMapViewDelegate>

@property (strong, nonatomic) NSDictionary *userLocation;

@end

@implementation ViewController 

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self.mapView setShowsUserLocation:YES];
    [self moveMapToNYC];
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    _userLocation = nil;
}

#pragma mark - Custom Actions

-(void)moveMapToNYC
{
    CLLocationCoordinate2D sf = CLLocationCoordinate2DMake(40.734381,-73.992748);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.040, 0.040);
    MKCoordinateRegion region = MKCoordinateRegionMake(sf, span);
    [self.mapView setRegion:region];
}

#pragma mark - MapView Delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.userLocation = @{@"lat":[NSNumber numberWithDouble:userLocation.coordinate.latitude], @"lng":[NSNumber numberWithDouble:userLocation.coordinate.longitude]};
    NSLog(@"%@", self.userLocation);
    [SVProgressHUD dismiss];
}

@end

//
//  ElevatorViewController.m
//  AccessWay
//
//  Created by Robin Chou on 5/5/13.
//  Copyright (c) 2013 Robin Chou. All rights reserved.
//

#import "CompassViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>

@interface CompassViewController () <CLLocationManagerDelegate>

@property (nonatomic, retain) NSArray *elevators;
@property (nonatomic, retain) NSArray *exits;
@property (nonatomic, retain) CLLocationManager *locationManager;

@end

@implementation CompassViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.alertView.layer setCornerRadius:100];
    [self.alertView setBackgroundColor:[UIColor blueColor]];
    
	// Do any additional setup after loading the view.
    if (![self.title isEqualToString:@"Elevators"]) {
        [self.textLabel setText:@"Your phone will vibrate when you face an exit"];
    }
    
    self.elevators = @[];
    if (self.elevators.count == 0)
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"There are no elevators at this stop.");
    
    self.exits = @[@{@"type": @"Stairwell", @"direction": @"NE"}, @{@"type":@"Stairwell", @"direction":@"SE"}];
    
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    [_locationManager startUpdatingHeading];
    [_locationManager setHeadingFilter:5.0f];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    NSLog(@"heading");
    if (newHeading.headingAccuracy > 0)
    {
        CLLocationDirection theHeading = newHeading.magneticHeading;
        NSLog(@"%f", theHeading);
    }
}

@end

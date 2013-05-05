//
//  ElevatorViewController.m
//  AccessWay
//
//  Created by Robin Chou on 5/5/13.
//  Copyright (c) 2013 Robin Chou. All rights reserved.
//

#import "CompassViewController.h"
#import <AudioToolbox/AudioServices.h>
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
    if (newHeading.headingAccuracy > 0)
    {
        CLLocationDirection theHeading = newHeading.magneticHeading;
        if (theHeading > 22.5 && theHeading < 67.5) {
            // north east
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"You are facing the North East stairwell");
            // vibrate and flash
            [self vibrateAndFlash];
            [self.detailTextLabel setText:@"Facing North East Corner"];
        } else if (theHeading > 112.5 && theHeading < 158.5) {
            // south east
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"You are facing the South East stairwell");
            // vibrate and flash
            [self vibrateAndFlash];
            [self.detailTextLabel setText:@"Facing South East Corner"];
        } else if (theHeading > 182.5 && theHeading < 247.5) {
            // south west
            [self.detailTextLabel setText:@"Facing South West Corner"];
        } else {
            // north west
            [self.detailTextLabel setText:@"Facing North West Corner"];
        }
    }
}

-(void)vibrateAndFlash
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end

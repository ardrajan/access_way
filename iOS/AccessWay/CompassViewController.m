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
    self.exits = @[@{@"type": @"Stairwell", @"direction": @"NE"}, @{@"type":@"Stairwell", @"direction":@"SE"}];
    
    if (self.elevators.count == 0)
        [self performSelector:@selector(notPresent) withObject:nil afterDelay:1.0];
    
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    [_locationManager startUpdatingHeading];
    [_locationManager setHeadingFilter:5.0f];
}

- (void)notPresent
{
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"There are no elevators at this stop.");
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
            // this is a hack
            if ([self.title isEqualToString:@"Exits"]) {
                UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"You are facing the North East stairwell");
                // vibrate and flash
                [self vibrateAndFlash];
                [self.detailTextLabel setText:@"Stairwell"];
            }
            [self.directionLabel setText:@"NE"];
        } else if (theHeading > 112.5 && theHeading < 158.5) {
            // south east
            if ([self.title isEqualToString:@"Exits"]) {
                UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, @"You are facing the South East stairwell");
                // vibrate and flash
                [self vibrateAndFlash];
                [self.detailTextLabel setText:@"Stairwell"];
            }
            [self.directionLabel setText:@"SE"];
        } else if (theHeading > 182.5 && theHeading < 247.5) {
            // south west
            [self.detailTextLabel setText:@""];
            [self.directionLabel setText:@"SW"];
        } else if (theHeading > 292.5 && theHeading < 337.5) {
            // north west
            [self.detailTextLabel setText:@""];
            [self.directionLabel setText:@"NW"];
        } else {
            [self.detailTextLabel setText:@""];
            [self.directionLabel setText:@""];
        }
    }
}

-(void)vibrateAndFlash
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end

//
//  InitialViewController.m
//  AccessWay
//
//  Created by Robin Chou on 5/5/13.
//  Copyright (c) 2013 Robin Chou. All rights reserved.
//

#import "InitialViewController.h"
#import "DLocationManager.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.textLabel setText:NSLocalizedString(@"AccessWay", nil)];
    self.textLabel.font = [UIFont boldFlatFontOfSize:26.0f];
    self.detailTextLabel.font = [UIFont flatFontOfSize:17.0f];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setToDefaultState];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"presentStationViewController"]) {
        
    }
}

#pragma mark - Location Methods

- (void)startUpdatingLocation
{
    [[DLocationManager sharedManager] retrieveUserLocationSuccess:^(CLLocationManager *manager, NSArray *locations) {
        [self performSegueWithIdentifier:@"presentStationViewController" sender:nil];
    } failure:^(CLLocationManager *manager, NSError *error) {
        [self setToConnectionUnsuccessful];
    }];
}

#pragma mark - IB Actions

- (IBAction)primaryButtonDidPress:(id)sender {
    [self setToConnectingState];
}

#pragma mark - View helper methods

- (void)setToDefaultState
{
    self.topConstraint.constant = 124.0f;
    self.primaryButton.alpha = 1.0f;
    [self.detailTextLabel setText:NSLocalizedString(@"For a more accessible subway", nil)];
    self.detailTextLabel.numberOfLines = 1;
    [self.detailTextLabel setTextAlignment:NSTextAlignmentCenter];
    [self resizeLabel:self.detailTextLabel];
    self.activityIndicator.alpha = 0.0f;
    self.retryButton.alpha = 0.0f;
}

- (void)setToConnectingState
{
    [UIView animateWithDuration:0.3f animations:^{
        self.retryButton.alpha = 0.0f;
        self.topConstraint.constant = 60.0f;
        [self.view layoutIfNeeded];
        self.detailTextLabel.alpha = 0.0f;
        self.primaryButton.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.detailTextLabel setText:NSLocalizedString(@"Hang on while we are trying to connect to the station you are in!", nil)];
        self.detailTextLabel.numberOfLines = 2;
        [self.detailTextLabel setTextAlignment:NSTextAlignmentCenter];
        [self resizeLabel:self.detailTextLabel];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.detailTextLabel.alpha = 1.0f;
            self.activityIndicator.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [self startUpdatingLocation];
        }];
    }];
}

- (void)setToConnectionUnsuccessful
{
    [UIView animateWithDuration:0.3f animations:^{
        self.detailTextLabel.alpha = 0.0f;
        self.activityIndicator.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.detailTextLabel setText:NSLocalizedString(@"Whoops, it looks like we were not able to connect.\n\nNo worries, check and make sure you are connected to the MTA wifi from within your Settings.", nil)];
        self.detailTextLabel.numberOfLines = 6;
        [self.detailTextLabel setTextAlignment:NSTextAlignmentLeft];
        [self resizeLabel:self.detailTextLabel];
        [UIView animateWithDuration:0.3 animations:^{
            self.detailTextLabel.alpha = 1.0f;
            self.retryButton.alpha = 1.0f;
        }];
    }];
}

- (void)resizeLabel:(UILabel *)label
{
    CGSize size = [label.text sizeWithFont:[UIFont flatFontOfSize:17.0f] constrainedToSize:CGSizeMake(260.0f, MAXFLOAT)];
    self.detailTextHeightConstraint.constant = size.height;
}

@end

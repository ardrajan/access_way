//
//  StationViewController.m
//  AccessWay
//
//  Created by Robin Chou on 7/19/13.
//  Copyright (c) 2013 Robin Chou. All rights reserved.
//

#import "StationViewController.h"

@interface StationViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *stationChoices;

@end

@implementation StationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.stationChoices = @[NSLocalizedString(@"Tell Me When Next Train Arrives", nil), NSLocalizedString(@"Service Changes For This Station", nil), NSLocalizedString(@"Exists and Elevator Information", nil)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stationChoices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *title = [self.stationChoices objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont flatFontOfSize:15.0f]];
    [cell.textLabel setText:title];
    return cell;
}

#pragma mark - IB Actions

- (IBAction)closeButtonDidPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

//
//  StationViewController.m
//  AccessWay
//
//  Created by Robin Chou on 7/19/13.
//  Copyright (c) 2013 Robin Chou. All rights reserved.
//

#import "StationViewController.h"
#import "NSDictionary+Stop.h"
#import "NSDictionary+Route.h"
#import "RoutesViewController.h"
#import "DLocationManager.h"

@interface StationViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *stationChoices;
@property (nonatomic, strong) NSArray *routesNearby;
@property (nonatomic, strong) NSMutableArray *routesForStation;

@end

@implementation StationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.routesForStation = [NSMutableArray arrayWithCapacity:0];

    self.stationChoices = @[NSLocalizedString(@"Tell Me When Next Train Arrives", nil), NSLocalizedString(@"Service Changes For This Station", nil), NSLocalizedString(@"Exists and Elevator Information", nil)];
    
    self.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Welcome to %@ Station", nil), [self.stop  stopName]];
    
    CLLocation *location = [DLocationManager sharedManager].location;
    [self findRoutesNearby:[NSString stringWithFormat:@"%0.7f", location.coordinate.latitude] longitude:[NSString stringWithFormat:@"%0.7f", location.coordinate.longitude]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushRoutesViewController"]) {
        RoutesViewController *vc = segue.destinationViewController;
        [vc setRoutes:[NSArray arrayWithArray:self.routesForStation]];
    }
}

- (void)findRoutesNearby:(NSString *)lat longitude:(NSString *)lng
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://node-gtfs.herokuapp.com/api/routesNearby/%@/%@/0.25", lat, lng]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseData) {
        self.routesNearby = responseData;
        [self findStops];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        DLog(@"%@", error);
    }];
    [operation start];
}

- (void)findStops
{
    for (NSDictionary *route in self.routesNearby) {
        [self findStopsForRoute:route agency:[self.stop agencyKey] direction:[NSNumber numberWithInteger:0]];
        [self findStopsForRoute:route agency:[self.stop agencyKey] direction:[NSNumber numberWithInteger:1]];
    }
}

- (void)findStopsForRoute:(NSDictionary *)route agency:(NSString *)agency direction:(NSNumber *)direction
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://node-gtfs.herokuapp.com/api/stops/%@/%@/%@", agency, [route routeId], direction]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseData) {
        NSArray *stops = responseData;
        [self crossReferenceStops:stops forRoute:route direction:direction];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        DLog(@"%@", error);
    }];
    [operation start];
}

- (void)crossReferenceStops:(NSArray *)stops forRoute:(NSDictionary *)route direction:(NSNumber *)direction;
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stop_id CONTAINS[cd] %@", [self.stop stopId]];
    NSArray *matches = [stops filteredArrayUsingPredicate:predicate];
    
    NSMutableDictionary *mutableRoute = [NSMutableDictionary dictionaryWithDictionary:route];
    [mutableRoute setObject:direction forKey:@"direction_id"];
    
    if (matches.count > 0) {
        [self.routesForStation addObject:mutableRoute];
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"pushRoutesViewController" sender:nil];
    }
}

#pragma mark - IB Actions

- (IBAction)closeButtonDidPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

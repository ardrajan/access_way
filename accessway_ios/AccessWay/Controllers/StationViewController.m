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
@property (nonatomic, assign) NSInteger fetchQueue;
@property (nonatomic, strong) NSTimer *retryTimer;

@end

@implementation StationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.stationChoices = @[NSLocalizedString(@"Tell Me When Next Train Arrives", nil), NSLocalizedString(@"Service Changes For This Station", nil), NSLocalizedString(@"Exists and Elevator Information", nil)];
    
    self.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Welcome to %@ Station", nil), [self.stop  stopName]];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    [self fetchRoutesNearby];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushRoutesViewController"]) {
        RoutesViewController *vc = segue.destinationViewController;
        NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"route_id" ascending:YES];
        NSSortDescriptor *directionSorter = [NSSortDescriptor sortDescriptorWithKey:@"direction_id" ascending:NO];
        [self.routesForStation sortUsingDescriptors:@[sorter, directionSorter]];
        [vc setRoutes:[NSArray arrayWithArray:self.routesForStation]];
        [vc setStop:self.stop];
        
        NSIndexPath *index = [self.tableView indexPathForSelectedRow];
        if (index.row == 0) {
            [vc setRouteInfoType:RouteInfoTypeTimes];
        } else {
            [vc setRouteInfoType:RouteInfoTypeServiceChanges];
        }
    }
}

- (void)fetchRoutesNearby
{
    self.fetchQueue = 0;
    CLLocation *location = [DLocationManager sharedManager].location;
    [self findRoutesNearby:[NSString stringWithFormat:@"%0.7f", location.coordinate.latitude] longitude:[NSString stringWithFormat:@"%0.7f", location.coordinate.longitude]];
}

- (void)findRoutesNearby:(NSString *)lat longitude:(NSString *)lng
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://node-gtfs.herokuapp.com/api/routesNearby/%@/%@/0.25", lat, lng]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseData) {
        self.routesNearby = responseData;
        [self findStops];
        self.fetchQueue -= 1;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        DLog(@"%@", error);
        [SVProgressHUD dismiss];
        self.fetchQueue -= 1;
    }];
    self.fetchQueue += 1;
    [operation start];
}

- (void)findStops
{
    self.routesForStation = [NSMutableArray arrayWithCapacity:0];
    
    for (NSDictionary *route in self.routesNearby) {
        [self findStopsForRoute:route agency:[self.stop agencyKey] direction:[NSNumber numberWithInteger:0]];
        [self findStopsForRoute:route agency:[self.stop agencyKey] direction:[NSNumber numberWithInteger:1]];
        self.fetchQueue += 2;
    }
}

- (void)findStopsForRoute:(NSDictionary *)route agency:(NSString *)agency direction:(NSNumber *)direction
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://node-gtfs.herokuapp.com/api/stops/%@/%@/%@", agency, [route routeId], direction]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseData) {
        NSArray *stops = responseData;
        [self crossReferenceStops:stops forRoute:route direction:direction];
        self.fetchQueue -= 1;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        DLog(@"%@", error);
        [SVProgressHUD dismiss];
        self.fetchQueue -= 1;
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
    if (indexPath.row == 0 || indexPath.row == 1) {
        if (self.fetchQueue != 0) {
            [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
            [self startRetryTimer];
            return;
        }
        [self pushRoutesViewController];
    }
}

#pragma mark - Custom Actions


- (void)startRetryTimer
{
    if (_retryTimer) {
        [_retryTimer invalidate];
    }
    self.retryTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(pushRoutesViewController) userInfo:nil repeats:YES];
}

- (void)stopRetryTimer
{
    if (_retryTimer) {
        [_retryTimer invalidate];
    }
}

- (void)pushRoutesViewController
{
    if (self.fetchQueue != 0) {
        return;
    }
    [self stopRetryTimer];
    [SVProgressHUD dismiss];
    [self performSegueWithIdentifier:@"pushRoutesViewController" sender:nil];
}

#pragma mark - IB Actions

- (IBAction)closeButtonDidPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

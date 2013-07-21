//
//  RoutesViewController.m
//  AccessWay
//
//  Created by Robin Chou on 7/20/13.
//  Copyright (c) 2013 Robin Chou. All rights reserved.
//

#import "RoutesViewController.h"
#import "NSDictionary+Route.h"
#import "RouteCell.h"
#import "RouteTimesViewController.h"

@interface RoutesViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation RoutesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushRouteTimesViewController"]) {
        RouteTimesViewController *vc = segue.destinationViewController;
        NSIndexPath *index = [self.tableView indexPathForSelectedRow];
        NSDictionary *route = [self.routes objectAtIndex:index.row];
        [vc setRoute:route];
        [vc setStop:self.stop];
    }
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.routes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RouteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *route = [self.routes objectAtIndex:indexPath.row];
    NSString *text = [[route direction_id] isEqualToNumber:[NSNumber numberWithInteger:1]] ? @"Uptown" : @"Downtown";
    [cell.nameLabel setText:text];
    [cell.routeLabel setText:[route routeId]];
    NSString *color = [route routeColor];
    cell.color = [UIColor colorFromHexCode:color];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.routeInfoType == RouteInfoTypeTimes) {
        [self performSegueWithIdentifier:@"pushRouteTimesViewController" sender:nil];
    }
}

@end

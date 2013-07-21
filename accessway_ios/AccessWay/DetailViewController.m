//
//  DetailViewController.m
//  Navigator
//
//  Created by Robin Chou on 5/4/13.
//  Copyright (c) 2013 Robin Chou. All rights reserved.
//

#import "DetailViewController.h"
#import "RouteCell.h"
#import "HeaderView.h"
#import "LineDetailViewController.h"

@interface DetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *routes;
@property (strong, nonatomic) NSMutableDictionary *routeData;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil]];
    
    self.routeData = [NSMutableDictionary dictionaryWithCapacity:0];
    [self getRoutesData];
    [self.textLabel setText:[[self.stop objectForKey:@"stop_name"] uppercaseString]];
    NSString *stopID = [[self.stop objectForKey:@"stop_id"] substringToIndex:3];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:3000/routes.json?stop_id=%@", stopID]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSString *routes = [[JSON objectAtIndex:0] objectForKey:@"name"];
        self.routes = [routes componentsSeparatedByString:@", "];
        [self.tableView setDelegate:self];
        [self.tableView setDataSource:self];
        [self.tableView reloadData];
    } failure:nil];
    [operation start];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

-(void)getRoutesData
{
    NSURL *url = [NSURL URLWithString:@"http://node-gtfs.herokuapp.com/api/routes/nyct"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        for (NSDictionary *route in JSON) {
            [self.routeData setObject:route forKey:[route objectForKey:@"route_id"]];
        }
    } failure:nil];
    [operation start];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *index = [self.tableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"pushLineDetailView"]) {
        NSString *key = [self.routes objectAtIndex:index.row];
        NSDictionary *route = [self.routeData objectForKey:key];
        LineDetailViewController *vc = segue.destinationViewController;
        [vc setRoute:route];
    } else {
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)dismissModalView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.routes.count;
    }
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        RouteCell *cell = (RouteCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        NSString *key = [self.routes objectAtIndex:indexPath.row];
        NSDictionary *route = [self.routeData objectForKey:key];
        NSString *color = [route objectForKey:@"route_color"];
        [cell.nameLabel setText:[route objectForKey:@"route_long_name"]];
        [cell.routeLabel setText:[route objectForKey:@"route_short_name"]];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disclosure_arrow"]];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basicCell"];
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Elevators"];
            [cell.imageView setImage:[UIImage imageNamed:@"elevator"]];
        } else {
            [cell.textLabel setText:@"Exits"];
            [cell.imageView setImage:[UIImage imageNamed:@"exit"]];
        }
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disclosure_arrow"]];
        return cell;
    }
}

#pragma mark - UITableView delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    HeaderView *view = [xibs objectAtIndex:0];
    if (section == 0) {
        [view.textLabel setText:@"Select a line for service info"];
    } else {
        [view.textLabel setText:@"Current Station Information"];
    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:@"pushLineDetailView" sender:self];
    } else {
        [self performSegueWithIdentifier:@"pushCompassView" sender:self];
    }
}

@end
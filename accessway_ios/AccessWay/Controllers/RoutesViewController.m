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

@interface RoutesViewController ()

@end

@implementation RoutesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
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



@end

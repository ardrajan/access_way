//
//  LineDetailViewController.m
//  AccessWay
//
//  Created by Robin Chou on 5/5/13.
//  Copyright (c) 2013 Robin Chou. All rights reserved.
//

#import "LineDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "HeaderView.h"

@interface LineDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation LineDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.lineLabel setText:[self.route objectForKey:@"route_short_name"]];
    [self.textLabel setText:[self.route objectForKey:@"route_long_name"]];
    [self.subLabel setText:[self.route objectForKey:@"agency_id"]];
    
    CGRect positionFrame = CGRectMake(19,46,44,44);
    UIView *circleView = [[UIView alloc] initWithFrame:positionFrame];
    circleView.backgroundColor = [self colorFromHexString:[self.route objectForKey:@"route_color"]];
    [circleView.layer setCornerRadius:22];
    [self.tableHeaderView insertSubview:circleView atIndex:2];
    
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell.textLabel setNumberOfLines:0];
    [cell.textLabel setText:[self.route objectForKey:@"route_desc"]];
    [cell.textLabel sizeToFit];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [self.route objectForKey:@"route_desc"];
    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f] constrainedToSize:CGSizeMake(300, 1000)];
    return size.height+30;
}

#pragma mark - UITableView delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    HeaderView *view = [xibs objectAtIndex:0];
    [view.textLabel setText:@"Route Information"];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

#pragma mark - Color Helper

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end

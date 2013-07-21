//
//  RouteTimesViewController.m
//  AccessWay
//
//  Created by Robin Chou on 7/20/13.
//  Copyright (c) 2013 Robin Chou. All rights reserved.
//

#import "RouteTimesViewController.h"
#import "NSDictionary+Route.h"
#import "NSDictionary+Stop.h"

@interface RouteTimesViewController ()

@property (nonatomic, strong) UIView *noTimesView;
@property (nonatomic, strong) NSArray *stopTimes;

@end

@implementation RouteTimesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self findTimesForStop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)findTimesForStop
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://node-gtfs.herokuapp.com/api/times/%@/%@/%@/%@", [self.stop agencyKey], [self.route routeId], [self.stop stopId], [self.route direction_id]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseData) {
        [SVProgressHUD dismiss];
        if ([responseData isKindOfClass:[NSDictionary class]]) {
            // Show no times for this stop
            [self showNoStopTimes];
            return;
        }
        
        [self hideNoTimesView];
        self.stopTimes = responseData;
        [self.tableView reloadData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        DLog(@"%@", error);
        [SVProgressHUD dismiss];
    }];
    [operation start];
}

- (void)showNoStopTimes
{
    if (!_noTimesView) {
        _noTimesView = [[UIView alloc] initWithFrame:self.view.frame];
        self.noTimesView.backgroundColor = [UIColor whiteColor];
        UILabel *noTimes = [[UILabel alloc] initWithFrame:self.view.frame];
        noTimes.textAlignment = NSTextAlignmentCenter;
        [noTimes setText:@"No times for this station"];
        [self.noTimesView addSubview:noTimes];
        [self.view addSubview:self.noTimesView];
    }
    
    self.noTimesView.alpha = 1.0f;
}

- (void)hideNoTimesView
{
    self.noTimesView.alpha = 0.0f;
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stopTimes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *time = [self.stopTimes objectAtIndex:indexPath.row];
    cell.textLabel.text = time;
    return cell;
}

@end

//
//  LineDetailViewController.m
//  AccessWay
//
//  Created by Robin Chou on 5/5/13.
//  Copyright (c) 2013 Robin Chou. All rights reserved.
//

#import "LineDetailViewController.h"

@interface LineDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation LineDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", self.route);
//    [_tableView setDelegate:self];
//    [_tableView setDataSource:self];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

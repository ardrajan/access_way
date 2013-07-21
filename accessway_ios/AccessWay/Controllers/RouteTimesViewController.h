//
//  RouteTimesViewController.h
//  AccessWay
//
//  Created by Robin Chou on 7/20/13.
//  Copyright (c) 2013 Robin Chou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteTimesViewController : UIViewController

@property (nonatomic, strong) NSDictionary *stop;
@property (nonatomic, strong) NSDictionary *route;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

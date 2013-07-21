//
//  RouteTimesViewController.h
//  AccessWay
//
//  Created by Robin Chou on 7/20/13.
//  Copyright (c) 2013 Robin Chou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteTimesViewController : UIViewController

@property (strong, nonatomic) NSDictionary *stop;
@property (strong, nonatomic) NSDictionary *route;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

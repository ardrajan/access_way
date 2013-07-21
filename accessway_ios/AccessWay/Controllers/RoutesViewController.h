//
//  RoutesViewController.h
//  AccessWay
//
//  Created by Robin Chou on 7/20/13.
//  Copyright (c) 2013 Robin Chou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    RouteInfoTypeTimes,
    RouteInfoTypeServiceChanges,
} RouteInfoType;

@interface RoutesViewController : UIViewController

@property (nonatomic, assign) RouteInfoType routeInfoType;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *stop;
@property (nonatomic, strong) NSArray *routes;

@end
//
//  LineDetailViewController.h
//  AccessWay
//
//  Created by Robin Chou on 5/5/13.
//  Copyright (c) 2013 Robin Chou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineDetailViewController : UIViewController

@property (strong, nonatomic) NSDictionary *route;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;

@end

//
//  StationViewController.h
//  AccessWay
//
//  Created by Robin Chou on 7/19/13.
//  Copyright (c) 2013 Robin Chou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (nonatomic, strong) NSDictionary *stop;

- (IBAction)closeButtonDidPress:(id)sender;

@end

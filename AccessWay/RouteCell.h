//
//  RouteCell.h
//  AccessWay
//
//  Created by Robin Chou on 5/4/13.
//  Copyright (c) 2013 Robin Chou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CircleView;

@interface RouteCell : UITableViewCell

@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) CircleView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeLabel;

@end

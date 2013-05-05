//
//  RouteCell.m
//  AccessWay
//
//  Created by Robin Chou on 5/4/13.
//  Copyright (c) 2013 Robin Chou. All rights reserved.
//

#import "RouteCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation RouteCell
@synthesize nameLabel, routeLabel;

-(void)awakeFromNib
{
    CGRect positionFrame = CGRectMake(8,16,28,28);
    self.circleView = [[UIView alloc] initWithFrame:positionFrame];
    [self.circleView.layer setCornerRadius:14];
    [self.contentView insertSubview:self.circleView atIndex:0];
}

-(void)setColor:(UIColor *)color
{
    _color = color;
    self.circleView.backgroundColor = color;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end

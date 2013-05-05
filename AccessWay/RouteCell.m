//
//  RouteCell.m
//  AccessWay
//
//  Created by Robin Chou on 5/4/13.
//  Copyright (c) 2013 Robin Chou. All rights reserved.
//

#import "RouteCell.h"
#import "CircleView.h"

@implementation RouteCell
@synthesize nameLabel, routeLabel;

-(void)awakeFromNib
{
    CGRect positionFrame = CGRectMake(15,15,30,30);
    self.circleView = [[CircleView alloc] initWithFrame:positionFrame];
    [self.contentView insertSubview:self.circleView atIndex:0];
}

-(void)setColor:(UIColor *)color
{
    _color = color;
    self.circleView.color = _color;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end

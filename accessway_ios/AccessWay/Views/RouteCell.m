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
    CGRect positionFrame = CGRectMake(10,15,30,30);
    self.circleView = [[UIView alloc] initWithFrame:positionFrame];
    [self.circleView.layer setCornerRadius:15];
    [self.contentView insertSubview:self.circleView atIndex:0];
    
    positionFrame = self.routeLabel.frame;
    positionFrame.origin.x = 15.5;
    self.routeLabel.frame = positionFrame;
    
    self.nameLabel.font = [UIFont boldFlatFontOfSize:18.0f];
}

-(void)setColor:(UIColor *)color
{
    _color = color;
    self.circleView.backgroundColor = color;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    self.circleView.backgroundColor = self.color;
}

@end

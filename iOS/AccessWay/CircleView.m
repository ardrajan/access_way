//
//  CircleView.m
//  AccessWay
//
//  Created by Robin Chou on 5/4/13.
//  Copyright (c) 2013 Robin Chou. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

- (void)drawRect:(CGRect)rect{
    CGContextRef context= UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, _color.CGColor);
    CGContextSetAlpha(context, 1);
    CGContextFillEllipseInRect(context, CGRectMake(0,0,self.frame.size.width,self.frame.size.height));
}

-(UIColor *)color
{
    if (!_color) {
        return [UIColor redColor];
    } else {
        return _color;
    }
}

@end

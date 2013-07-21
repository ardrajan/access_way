//
//  NSDictionary+Route.m
//  AccessWay
//
//  Created by Robin Chou on 7/20/13.
//  Copyright (c) 2013 Robin Chou. All rights reserved.
//

#import "NSDictionary+Route.h"

@implementation NSDictionary (Route)

- (NSString *)routeId
{
    return [self objectForKey:@"route_id"];
}

- (NSNumber *)direction_id
{
    return [self objectForKey:@"direction_id"];
}

- (NSString *)routeColor
{
    return [self objectForKey:@"route_color"];
}

- (NSString *)routeShortName
{
    return [self objectForKey:@"route_short_name"];
}

@end

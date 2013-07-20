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

@end

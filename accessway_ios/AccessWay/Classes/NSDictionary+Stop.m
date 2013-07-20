//
//  NSDictionary+Stop.m
//  AccessWay
//
//  Created by Robin Chou on 7/20/13.
//  Copyright (c) 2013 Robin Chou. All rights reserved.
//

#import "NSDictionary+Stop.h"

@implementation NSDictionary (Stop)

- (NSString *)stopId;
{
    return [self objectForKey:@"stop_id"];
}

- (NSString *)stopName;
{
    return [self objectForKey:@"stop_name"];
}

- (NSString *)agencyKey;
{
    return [self objectForKey:@"agency_key"];
}

@end

//
//  StopData.h
//  Navigator
//
//  Created by Robin Chou on 5/4/13.
//  Copyright (c) 2013 Robin Chou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StopData : NSObject

@property (strong, nonatomic) NSString *stopID;
@property (strong, nonatomic) NSNumber *lat;
@property (strong, nonatomic) NSNumber *lng;
@property (strong, nonatomic) NSDictionary *data;

@end

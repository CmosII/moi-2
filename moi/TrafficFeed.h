//
//  TrafficFeed.h
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/25/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrafficFeed : NSObject
@property(nonatomic,readwrite)int feedID;
@property(nonatomic,retain)NSString *streetName;
@property(nonatomic,retain)NSString *city;
@property(nonatomic,retain)NSString *feedDate;
@property(nonatomic,retain)NSString *description;
@property(nonatomic,readwrite)int feedType;
@end

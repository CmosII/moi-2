//
//  Worker.h
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/24/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Worker : NSObject
@property (nonatomic,readwrite)int feedID;
@property (nonatomic,retain) NSString *workerID;
@property (nonatomic,retain) NSString *guarantorID;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *sex;
@property (nonatomic,retain) NSString *feedDetails;
@end

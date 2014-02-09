//
//  AnnotationPoint.m
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/16/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "AnnotationPoint.h"

@implementation AnnotationPoint
@synthesize catID,annTitle,annSubTitle,coordinate;

- (NSString *)subtitle{
	return annSubTitle;
}
- (NSString *)title{
	return annTitle;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	return self;
}

@end

//
//  AnnotationPoint.h
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/16/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AnnotationPoint : NSObject <MKAnnotation>
@property(nonatomic,readwrite)NSUInteger catID;
@property(nonatomic,retain)NSString *annTitle;
@property(nonatomic,retain)NSString *annSubTitle;
@property(nonatomic,readwrite)CLLocationCoordinate2D coordinate;
-(id)initWithCoordinate:(CLLocationCoordinate2D) c;

@end

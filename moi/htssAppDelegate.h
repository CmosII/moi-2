//
//  htssAppDelegate.h
//  moi
//
//  Created by shjmun Mac on 11/11/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "User.h"

@interface htssAppDelegate : UIResponder <UIApplicationDelegate>
{
    BOOL isAR;
    
    NSString *userName;
    NSString *userCategory;
    
    double selectedSafariCoordLong;
    double selectedSafariCoordLat;
    int safariID;
    
    User *aUser;
    
    CLLocationManager *locationManager;
    
    UILocalNotification *safariNotification;
    
    NSUserDefaults *defaults;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readwrite) BOOL isAR;
@property (nonatomic, readwrite) BOOL isSafariOn;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *userCategory;
@property (nonatomic, readwrite)double selectedSafariCoordLong;
@property (nonatomic, readwrite)double selectedSafariCoordLat;
@property (nonatomic, readwrite)int safariID;
@property (nonatomic, retain)User *aUser;
@property (nonatomic, retain)CLLocationManager *locationManager;
@property (nonatomic, retain)UILocalNotification *safariNotification;
@property (nonatomic, retain) NSString *webURL;
@property (nonatomic, retain) NSUserDefaults *defaults;
@end

//
//  htssAppDelegate.m
//  moi
//
//  Created by shjmun Mac on 11/11/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

/*Defaults List
 NSString userName
 NSString userCategory
 BOOL isAR
 BOOL isSafariOn
 double selectedSafariCoordLong
 double selectedSafariCoordLat
 User aUser:-
     aUser.Email
     aUser.IDNumber
     aUser.name
     aUser.nationality
     aUser.dob
     aUser.sex
 */

#import "htssAppDelegate.h"

@implementation htssAppDelegate
@synthesize isAR,userName,userCategory,isSafariOn,selectedSafariCoordLat,selectedSafariCoordLong,aUser,locationManager,safariNotification,safariID,webURL,defaults;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    locationManager = [[CLLocationManager alloc]init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    defaults = [NSUserDefaults standardUserDefaults];
    isAR = [defaults boolForKey:@"isAR"];
    userName = [defaults stringForKey:@"userName"];
    NSLog(@"didFinishLaunchingWithOptions - userName: %@",userName);
    userCategory = [defaults stringForKey:@"userCategory"];
    NSLog(@"userCategory: %@",userCategory);
    isSafariOn = [defaults boolForKey:@"isSafariOn"];
    selectedSafariCoordLat = [defaults doubleForKey:@"selectedSafariCoordLat"];
    selectedSafariCoordLong = [defaults doubleForKey:@"selectedSafariCoordLong"];
    
    aUser = [[User alloc]init];
    aUser.Email = [defaults stringForKey:@"Email"];
    aUser.IDNumber = [defaults stringForKey:@"IDNumber"];
    aUser.name = [defaults stringForKey:@"name"];
    aUser.nationality = [defaults stringForKey:@"nationality"];
    aUser.dob = [defaults stringForKey:@"dob"];
    aUser.sex = [defaults stringForKey:@"sex"];
    aUser.userCategory = [defaults stringForKey:@"userCategory"];
    NSLog(@"aUser.userCategory: %@",aUser.userCategory);
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    //NSLog(@"saveLocalNotificationOn - dateTo: %@",dateTo);
    UIApplication *app = [UIApplication sharedApplication];
    if ([safariNotification.alertAction isEqualToString:@"سفاري"]) {
        if (safariNotification) {
            NSLog(@"applicationDidEnterBackground - notifyAlarm: %@",safariNotification.fireDate);
            NSDate *safariToDate = safariNotification.fireDate;
            [app scheduleLocalNotification:safariNotification];
            
            safariNotification.fireDate = [safariToDate dateByAddingTimeInterval:(1 * 60)];
            [app scheduleLocalNotification:safariNotification];
            
            safariNotification.fireDate = [safariToDate dateByAddingTimeInterval:(2 * 60)];
            [app scheduleLocalNotification:safariNotification];
            
            safariNotification.fireDate = [safariToDate dateByAddingTimeInterval:(3 * 60)];
            [app scheduleLocalNotification:safariNotification];
            
            safariNotification.fireDate = [safariToDate dateByAddingTimeInterval:(4 * 60)];
            [app scheduleLocalNotification:safariNotification];
        }
    }
    NSLog(@"defaults userName: %@",[defaults stringForKey:@"userCategory"]);
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

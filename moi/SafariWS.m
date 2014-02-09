//
//  SafariWS.m
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/16/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "SafariWS.h"
#import "AFNetworking.h"

@implementation SafariWS

-(void)SubmitSafariTripLong:(double)longitude
                             Lat:(double)latitude
                            From:(NSDate*)dFrom
                              To:(NSDate*)dTo
                            Desc:(NSString*)Description
                          mNames:(NSArray*)MemberNames
                         mPhones:(NSArray*)MemberPhones
                          cNames:(NSArray*)ContactNames
                         cPhones:(NSArray*)ContactPhones
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    appDelegate = (htssAppDelegate*)[[UIApplication sharedApplication]delegate];
    defaults = [NSUserDefaults standardUserDefaults];
    @try {
        NSString *mc1 = [MemberPhones objectAtIndex:0];
        NSString *mn1 = [MemberNames objectAtIndex:0];
        NSString *cc1 = [ContactPhones objectAtIndex:0];
        NSString *cn1 = [ContactNames objectAtIndex:0];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM-dd-yyyy hh:mm a"];
        NSString *dtFrom = [NSString stringWithFormat:@"%@",[df stringFromDate:dFrom]];
        NSString *dtTo = [NSString stringWithFormat:@"%@",[df stringFromDate:dTo]];
        NSString *soapBody = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
        "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
        "<soap:Body>";
        //========================parameters========================
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<insertSafariTrip xmlns=\"http://tempuri.org/\">"]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<Longitude>%f</Longitude>",longitude]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<Latitude>%f</Latitude>",latitude]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<UserName>%@</UserName>",appDelegate.userName]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<ContactNumber>%@</ContactNumber>",cc1]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<ContactName>%@</ContactName>",cn1]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<MemberNumber>%@</MemberNumber>",mc1]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<MemberName>%@</MemberName>",mn1]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<dtFrom>%@</dtFrom>",dtFrom]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<dtTo>%@</dtTo>",dtTo]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<locationDesc>%@</locationDesc>",Description]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"</insertSafariTrip>"]];
        //======================end=parameters======================
        soapBody = [soapBody stringByAppendingString:
                    @"</soap:Body>"
                    "</soap:Envelope>"];
        
        NSString *baseURL = @"http://www.htss.somee.com/beladiws.asmx";
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:baseURL]];
        [request setHTTPBody:[soapBody dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"www.htss.somee.com" forHTTPHeaderField:@"Host"];
        [request addValue:@"http://tempuri.org/insertSafariTrip" forHTTPHeaderField:@"SOAPAction"];
        
        
        AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
            logParser = XMLParser;
            logParser.delegate = self;
            [logParser parse];
            int tResponse = [wsResponse intValue];
            if (tResponse > 1) {
                appDelegate.safariID = tResponse;
                [self finishedSubmitionDate:dTo];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"حالة الرحلة"
                                                               message:[NSString stringWithFormat:@"تم تسجيل الرحلة %i بنجاح",tResponse]
                                                              delegate:nil
                                                     cancelButtonTitle:@"العودة"
                                                     otherButtonTitles:nil];
                [alert show];
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        } failure:
                                            ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser){
                                                
                                                NSLog(@"Operation Failed");
                                                NSLog(@"Reponse.Description: %@",response.description);
                                                NSLog(@"error.description: %@",error.description);
                                            }] ;
        [operation start];
    }
    @catch (NSException *exception) {
        NSLog(@"LogClassName: Caught %@: %@", [exception name], [exception reason]);
    }
}

-(void)finishedSubmitionDate:(NSDate*)dateTo{
    appDelegate.isSafariOn = YES;
    [defaults setBool:appDelegate.isSafariOn forKey:@"isSafariOn"];
    [defaults synchronize];
    [self saveLocalNotificationOn:dateTo];
}

-(void)EditSafariTripLong:(double)longitude
                      Lat:(double)latitude
                     From:(NSDate*)dFrom
                       To:(NSDate*)dTo
                     Desc:(NSString*)Description
                   mNames:(NSArray*)MemberNames
                  mPhones:(NSArray*)MemberPhones
                   cNames:(NSArray*)ContactNames
                  cPhones:(NSArray*)ContactPhones
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    appDelegate = (htssAppDelegate*)[[UIApplication sharedApplication]delegate];
    defaults = [NSUserDefaults standardUserDefaults];
    @try {
        NSString *mc1 = [MemberPhones objectAtIndex:0];
        NSString *mn1 = [MemberNames objectAtIndex:0];
        NSString *cc1 = [ContactPhones objectAtIndex:0];
        NSString *cn1 = [ContactNames objectAtIndex:0];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM-dd-yyyy hh:mm a"];
        NSString *dtFrom = [NSString stringWithFormat:@"%@",[df stringFromDate:dFrom]];
        NSString *dtTo = [NSString stringWithFormat:@"%@",[df stringFromDate:dTo]];
        NSString *soapBody = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
        "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
        "<soap:Body>";
        //========================parameters========================
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<editSafariTrip xmlns=\"http://tempuri.org/\">"]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<safariID>%i</safariID>",appDelegate.safariID]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<Longitude>%f</Longitude>",longitude]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<Latitude>%f</Latitude>",latitude]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<UserName>%@</UserName>",appDelegate.userName]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<ContactNumber>%@</ContactNumber>",cc1]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<ContactName>%@</ContactName>",cn1]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<MemberNumber>%@</MemberNumber>",mc1]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<MemberName>%@</MemberName>",mn1]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<dtFrom>%@</dtFrom>",dtFrom]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<dtTo>%@</dtTo>",dtTo]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<locationDesc>%@</locationDesc>",Description]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"</editSafariTrip>"]];
        //======================end=parameters======================
        soapBody = [soapBody stringByAppendingString:
                    @"</soap:Body>"
                    "</soap:Envelope>"];
        
        NSString *baseURL = @"http://www.htss.somee.com/beladiws.asmx";
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:baseURL]];
        [request setHTTPBody:[soapBody dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"www.htss.somee.com" forHTTPHeaderField:@"Host"];
        [request addValue:@"http://tempuri.org/editSafariTrip" forHTTPHeaderField:@"SOAPAction"];
        
        
        AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
            logParser = XMLParser;
            logParser.delegate = self;
            [logParser parse];
            int tResponse = [wsResponse intValue];
            if (tResponse > 1) {
                [self finishedSubmitionDate:dTo];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"حالة تعديل الرحلة"
                                                               message:[NSString stringWithFormat:@"تم تعديل بيانات الرحلة %i بنجاح",tResponse]
                                                              delegate:nil
                                                     cancelButtonTitle:@"العودة"
                                                     otherButtonTitles:nil];
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"حالة تعديل الرحلة"
                                                               message:[NSString stringWithFormat:@"الخدمة غير متوفرة حاليا ، سيتم العمل على إرجاعها في أقرب وقت ممكن"]
                                                              delegate:nil
                                                     cancelButtonTitle:@"العودة"
                                                     otherButtonTitles:nil];
                [alert show];
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        } failure:
                                            ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser){
                                                
                                                NSLog(@"Operation Failed");
                                                NSLog(@"Reponse.Description: %@",response.description);
                                                NSLog(@"error.description: %@",error.description);
                                            }] ;
        [operation start];
    }
    @catch (NSException *exception) {
        NSLog(@"LogClassName: Caught %@: %@", [exception name], [exception reason]);
    }
}

-(void)saveLocalNotificationOn:(NSDate*)dateTo
{
    NSLog(@"saveLocalNotificationOn - dateTo: %@",dateTo);
    UILocalNotification *notifyAlarm = [[UILocalNotification alloc]init];
    if (notifyAlarm) {
        notifyAlarm.fireDate = dateTo;
        notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
        notifyAlarm.repeatInterval = 0;
        notifyAlarm.soundName = @"alarm.wav";
        notifyAlarm.alertAction = @"سفاري";
        notifyAlarm.alertBody = @"الرجاء الإعلام بحالة الرحلة";
        appDelegate.safariNotification = notifyAlarm;
    }
    /*[notifyAlarm setFireDate:[NSDate dateWithTimeIntervalSinceNow:5]];
    [notifyAlarm setTimeZone:[NSTimeZone defaultTimeZone]];
    [app setScheduledLocalNotifications:[NSArray arrayWithObject:notifyAlarm]];*/
    /*UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    NSLog(@"fireDate: %@",localNotification.fireDate);
    localNotification.alertBody = @"Your alert message";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];*/
    /*NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:23];
    [dateComps setMonth:11];
    [dateComps setYear:2013];
    [dateComps setHour:19];
    [dateComps setMinute:00];
    NSDate *itemDate = [calendar dateFromComponents:dateComps];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = [itemDate addTimeInterval:-10];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    //localNotif.alertBody = [NSString stringWithFormat:NSLocalizedString(@"%@ in %i minutes.", nil),
                            //item.eventName, minutesBefore];
    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
    //NSDictionary *infoDict = [NSDictionary dictionaryWithObject:item.eventName forKey:ToDoItemKey];
    //localNotif.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];*/
    /*NSDate *alarmTime = [[NSDate alloc]dateByAddingTimeInterval:5];
    UIApplication *app = [UIApplication sharedApplication];
    UILocalNotification *notifyAlarm = [[UILocalNotification alloc]init];
    if (notifyAlarm) {
        notifyAlarm.fireDate = alarmTime;
        NSLog(@"saveLocalNotificationOn - alarmTime: %@",alarmTime);
        notifyAlarm.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"Europe/London"];
        notifyAlarm.repeatInterval = 0;
        notifyAlarm.soundName = @"alarm.wav";
        notifyAlarm.alertBody = @"Alert Body Test!";
        [app scheduleLocalNotification:notifyAlarm];
    }*/
}

#pragma mark -
#pragma mark XML Parser

- (void)parser:(NSXMLParser*)parser
foundCharacters:(NSString*)string
{
    if (parser == logParser) {
        wsResponse = string;
    }else{
        NSLog(@"parsing something else\nfoundCharacters: %@",string);
    }
}

@end

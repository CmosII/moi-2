//
//  AinSaheraWS.m
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/19/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import "AinSaheraWS.h"
#import "ImageUploaderWS.h"
#import "AFNetworking.h"

@implementation AinSaheraWS

-(void)SubmitIssueContactName:(NSString*)contactName
                ContactNumber:(NSString*)contactNumber
                        longi:(double)longitude
                          Lat:(double)latitude
                         Desc:(NSString*)Description
                  SubmitImage:(UIImage*)img
                     IssueCat:(int)issueCat
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    appDelegate = (htssAppDelegate*)[[UIApplication sharedApplication]delegate];
    defaults = [NSUserDefaults standardUserDefaults];
    @try {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM-dd-yyyy hh:mm a"];
        NSString *issueDate = [NSString stringWithFormat:@"%@",[df stringFromDate:[NSDate date]]];
        NSString *soapBody = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
        "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
        "<soap:Body>";
        //========================parameters========================
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<insertIssue xmlns=\"http://tempuri.org/\">"]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<ContactName>%@</ContactName>",contactName]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<IssueDate>%@</IssueDate>",issueDate]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<Longitude>%f</Longitude>",longitude]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<Latitude>%f</Latitude>",latitude]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<UserName>%@</UserName>",appDelegate.userName]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<ContactNumber>%@</ContactNumber>",contactNumber]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<IssueCategory>%i</IssueCategory>",issueCat]];
        if (img == nil) {
            soapBody = [soapBody stringByAppendingString:@"<MediaStatus>Y</MediaStatus>"];
        }else{
            soapBody = [soapBody stringByAppendingString:@"<MediaStatus>N</MediaStatus>"];
        }
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"<Description>%@</Description>",Description]];
        soapBody = [soapBody stringByAppendingString:[NSString stringWithFormat:@"</insertIssue>"]];
        //======================end=parameters======================
        soapBody = [soapBody stringByAppendingString:
                    @"</soap:Body>"
                    "</soap:Envelope>"];
        
        NSLog(@"AinSaheraWS - soapBody: %@",soapBody);
        
        NSString *baseURL = @"http://www.htss.somee.com/beladiws.asmx";
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:baseURL]];
        [request setHTTPBody:[soapBody dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"www.htss.somee.com" forHTTPHeaderField:@"Host"];
        [request addValue:@"http://tempuri.org/insertIssue" forHTTPHeaderField:@"SOAPAction"];
        
        
        AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
            logParser = XMLParser;
            logParser.delegate = self;
            [logParser parse];
            int responseValue = [wsResponse intValue];
            NSLog(@"Issue ID = %i",responseValue);
            if (responseValue > 0 && img != nil) {
                ImageUploaderWS *iws = [[ImageUploaderWS alloc]init];
                [iws UploadImageIssueID:responseValue Image:img];
            }else{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }
        } failure:
                                            ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser){
                                                
                                                NSLog(@"Operation Failed");
                                                NSLog(@"Reponse.Description: %@",response.description);
                                                NSLog(@"error.description: %@",error.description);
                                            }] ;
        [operation start];
    }
    @catch (NSException *exception) {
        NSLog(@"SubmitIssueContactName: Caught %@: %@", [exception name], [exception reason]);
    }
}

#pragma mark -
#pragma mark XML Parser

- (void)parser:(NSXMLParser*)parser
foundCharacters:(NSString*)string
{
    if (parser == logParser) {
        wsResponse = string;
        NSLog(@"wsResponse: %@",wsResponse);
    }else{
        NSLog(@"parsing something else\nfoundCharacters: %@",string);
    }
}

@end

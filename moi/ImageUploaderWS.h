//
//  ImageUploaderWS.h
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/19/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageUploaderWS : NSObject
-(void)UploadImageIssueID:(int)IID
                    Image:(UIImage*)img;

@end

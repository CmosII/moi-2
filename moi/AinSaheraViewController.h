//
//  AinSaheraViewController.h
//  moi
//
//  Created by Hamad Ahmed Theyab on 11/18/13.
//  Copyright (c) 2013 htss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "htssAppDelegate.h"

@interface AinSaheraViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    htssAppDelegate *appDelegate;
    NSUserDefaults *defaults;
}
@property(strong,nonatomic)UIButton *btnMenu;
@end

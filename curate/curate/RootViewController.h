//
//  RootViewController.h
//  curate
//
//  Created by Xcode Projects on 2/22/15.
//  Copyright (c) 2015 Curaté. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CE_SERVER_URL @"https://curate-anthonytopper.c9.io/"

#import <CoreLocation/CoreLocation.h>

@interface RootViewController : UIViewController <CLLocationManagerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *priceTag;
@property CLLocationDegrees latitude, longitude;

@end

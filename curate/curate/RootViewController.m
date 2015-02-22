//
//  RootViewController.m
//  curate
//
//  Created by Xcode Projects on 2/22/15.
//  Copyright (c) 2015 Curaté. All rights reserved.
//

#import "RootViewController.h"
#import "PostRequest.h"
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CLLocationManager *locManager = [[CLLocationManager alloc] init];
    locManager.delegate = self;
    
    locManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locManager.distanceFilter = 500;
    [locManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *loc = [locations objectAtIndex:0];
    self.latitude = loc.coordinate.latitude;
    self.longitude = loc.coordinate.longitude;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)curate:(id)sender {
    int num = self.priceTag.text.intValue;
    
    NSDictionary *dict = [NSDictionary dictionary];
    
    [dict setValue:[NSNumber numberWithInt:num] forKey:@"price"];
    [dict setValue:[NSNumber numberWithFloat:(float)self.latitude] forKey:@"latitude"];
    [dict setValue:[NSNumber numberWithFloat:(float)self.longitude] forKey:@"longitude"];
    [dict setValue:[NSNumber numberWithUnsignedInteger:(unsigned)time(NULL)] forKey:@"time"];
    
    PostRequest *request = [[PostRequest alloc] init];
    [request postRequestToURL:CE_SERVER_URL withPostData:[self stringifyJSON:dict] callback:^(NSString *response,NSError *error){
        if (error || !response) return;
        
        NSLog(@"Received: %@",response);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSString *)stringifyJSON:(NSDictionary *) dict {
    NSError *error;
    NSData *data = [[CJSONSerializer serializer] serializeDictionary:dict error:&error];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

-(NSDictionary*) parseJSON:(NSString*) json {
    NSError *error;
    NSDictionary *d = [[CJSONDeserializer deserializer] deserializeAsDictionary:[json dataUsingEncoding:NSUTF8StringEncoding] error:&error];
    
    if (error) {
        NSLog(@"ERROR IN parseJSON: %@",error);
    }
    
    return d;
    
}

@end

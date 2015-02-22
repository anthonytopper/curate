//
//  ViewController.m
//  curate
//
//  Created by Abhinav Kurada on 2/22/15.
//  Copyright (c) 2015 Curaté. All rights reserved.
//

#import "ViewController.h"
#import "PostRequest.h"
#import "CJSONDeserializer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    PostRequest *request = [[PostRequest alloc] init];
    [request postRequestToURL:CE_SERVER_URL withPostData:@"" callback:^(NSString *response,NSError *error){
        if (error || !response) return;
        
        NSLog(@"Received: %@",response);
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

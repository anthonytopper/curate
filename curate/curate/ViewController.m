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
#import "CJSONSerializer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    PostRequest *request = [[PostRequest alloc] init];
    [request postRequestToURL:CE_SERVER_URL withPostData:@"WIKS" callback:^(NSString *response,NSError *error){
        if (error || !response) return;
        
        NSLog(@"Received: %@",response);
        // 
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

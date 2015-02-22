//
//  ViewController.m
//  curate
//
//  Created by Abhinav Kurada on 2/22/15.
//  Copyright (c) 2015 Curaté. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) postRequestToURL:(NSString*) url withPostData:(NSData*) post {
    NS[NSURL URLWithString:url];
    NSString *length = [NSString stringWithFormat:@"%d",[post length]];
}

@end

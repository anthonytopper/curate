//
//  PostRequest.m
//  curate
//
//  Created by Abhinav Kurada on 2/22/15.
//  Copyright (c) 2015 Curaté. All rights reserved.
//

#import "PostRequest.h"

@implementation PostRequest

-(BOOL) postRequestToURL:(NSString*) url withPostData:(NSString*) post callback:(PostCallback) cb {
    
    NSData *postData = [post dataUsingEncoding:CE_POST_ENCODING];
    NSString *length = [NSString stringWithFormat:@"%lul",(unsigned long)[postData length]];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [req setHTTPMethod:@"POST"];
    [req setValue:length forHTTPHeaderField:@"Content-Length"];
    [req setHTTPBody:postData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (connection) {
        
        
    } else {
        NSLog(@"CONNECTION FAILED to URL: %@",url);
        return false;
    }
    
    response = [[NSMutableData alloc] init];
    callback = cb;
    
    return true;
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
    [response appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (callback != NULL) {
        callback(nil,error);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *dataStr = [[NSString alloc] initWithData:response encoding:CE_POST_ENCODING];
    if (callback != NULL) {
        callback(dataStr,nil);
    }
}


@end

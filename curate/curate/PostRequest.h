//
//  PostRequest.h
//  curate
//
//  Created by Abhinav Kurada on 2/22/15.
//  Copyright (c) 2015 Curaté. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CE_POST_ENCODING NSUTF8StringEncoding // NSASCIIStringEncoding

typedef void(^PostCallback)(NSString*,NSError*);

@interface PostRequest : NSObject {
    NSMutableData *response;
    PostCallback callback;
}
-(BOOL) postRequestToURL:(NSString*) url withPostData:(NSString*) post callback:(PostCallback) callback;
@end

//
//  JSONHelper.m
//  ImageDownloader
//
//  Created by Juncheng Han on 11/10/16.
//  Copyright © 2016 Juncheng Han. All rights reserved.
//

#import "JSONHelper.h"

@implementation JSONHelper

#pragma mark - lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    
}

- (void)fetchJSONDataWithURL:(NSString *)url completion:(JSONFetchCompletion)completion {
    
    NSURL *jsonURL = [NSURL URLWithString:url];
    
    NSURLSessionTask *jsonFetchTask = [[NSURLSession sharedSession] dataTaskWithURL:jsonURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        
        if (data) {
            
            NSError *jsonError;
            @try {
                NSArray *jsonContainer = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(jsonContainer);
                    });
                }
            }
            @catch (NSException *exception) {
            }
            @finally {
            }
        }
    }];
    
    [jsonFetchTask resume];
    
}

@end

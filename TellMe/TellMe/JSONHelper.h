//
//  JSONHelper.h
//  ImageDownloader
//
//  Created by Juncheng Han on 11/10/16.
//  Copyright © 2016 Juncheng Han. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^JSONFetchCompletion)(NSArray *data);

@interface JSONHelper : NSObject

- (void)fetchJSONDataWithURL:(NSString *)url completion:(JSONFetchCompletion)completion;

@end

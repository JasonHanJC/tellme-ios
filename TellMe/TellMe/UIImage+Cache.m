//
//  UIImage+Cache.m
//  ImageDownloader
//
//  Created by Juncheng Han on 11/9/16.
//  Copyright © 2016 Juncheng Han. All rights reserved.
//

#import "UIImage+Cache.h"
#import "ImageCacheManager.h"

@implementation UIImage (Cache)

+ (void)getImageWithURL:(NSString *)url completion:(DownloadCompletion)completion {
    
    [[ImageCacheManager shareInstance] downloadImageUsingNSURLSessionWithURL:url completion:completion];
    //[[ImageCacheManager shareInstance] downloadImageUsingNSDataWithURL:url completion:completion];

}


@end

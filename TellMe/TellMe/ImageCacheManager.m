
#import "ImageCacheManager.h"

@interface ImageCacheManager ()
@property (nonatomic, strong) NSMutableDictionary *imageCache;
@property (nonatomic, strong) NSMutableArray *lruArray;
@property (nonatomic, assign) NSInteger maxOfCache;
@end

@implementation ImageCacheManager

#pragma mark - lifecycle
- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageCache = [[NSMutableDictionary alloc] init];
        self.lruArray = [[NSMutableArray alloc] init];
        self.maxOfCache = 10;
    }
    return self;
}

- (void)dealloc {
    self.imageCache = nil;
    self.lruArray = nil;
}

+ (instancetype)shareInstance {
    static ImageCacheManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ImageCacheManager alloc] init];
    });
    return instance;
}

#pragma mark - caching
- (void)addNewImage:(UIImage *)image withKey:(NSString *)key {
    
    if ([self.imageCache objectForKey:key]) {
        
        [self.lruArray removeObject:key];
        [self.lruArray addObject:key];
    } else {
    
        if (self.lruArray.count < self.maxOfCache) {
            [self.lruArray addObject:key];
            [self.imageCache setObject:image forKey:key];

        } else {
            
            [self.imageCache removeObjectForKey:self.lruArray[0]];
            [self.lruArray removeObjectAtIndex:0];
            
            [self.lruArray addObject:key];
            [self.imageCache setObject:image forKey:key];
        }
    }
}

- (UIImage *)findImageWithKey:(NSString *)key {
    if (key) {
        if ([self.imageCache objectForKey:key]) {
            UIImage *image = [self.imageCache objectForKey:key];
            
            [self.lruArray removeObject:key];
            [self.lruArray addObject:key];
            
            return image;
        }
    }
    return nil;
}

#pragma mark - downloader
- (void)downloadImageUsingNSURLSessionWithURL:(NSString *)url completion:(DownloadCompletion)completion {
    
    UIImage *image = [self findImageWithKey:url];
    if (image) {
        NSLog(@"image found");
        if (completion)
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(YES, image);
            });
        return;
    }
    
    NSURL *imageURL = [NSURL URLWithString:url];

    NSURLSessionDataTask *downloadImageTask = [[NSURLSession sharedSession] dataTaskWithURL:imageURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error: %@", error);
        }
        
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            [self addNewImage:image withKey:url];
            if (completion)
                dispatch_async(dispatch_get_main_queue(), ^{
                    //NSLog(@"%@ \n %@", self.imageCache, self.lruArray);
                    completion(YES, image);
                });
        }
        
        if (completion)
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(NO, nil);
        });
    }];
    
    [downloadImageTask resume];
}

- (void)downloadImageUsingNSDataWithURL:(NSString *)url completion:(DownloadCompletion)completion {
    
    UIImage *image = [self findImageWithKey:url];
    
    if (image) {
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(YES, image);
            });
        }
        return;
    }
    
    // download image
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *imageURL = [NSURL URLWithString:url];
        
        NSData *data = [NSData dataWithContentsOfURL:imageURL];
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            [self addNewImage:image withKey:url];
            if (completion)
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(YES, image);
                });
        } else {
            if (completion)
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(NO, nil);
                });
        }
    });
    
}

@end


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^DownloadCompletion)(BOOL seccess, UIImage *image);

@interface ImageCacheManager : NSObject

+ (instancetype)shareInstance;

- (void)downloadImageUsingNSURLSessionWithURL:(NSString *)url completion:(DownloadCompletion)completion;
- (void)downloadImageUsingNSDataWithURL:(NSString *)url completion:(DownloadCompletion)completion;

@end

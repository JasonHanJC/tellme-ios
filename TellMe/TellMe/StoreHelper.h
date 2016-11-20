//
//  StoreHelper.h
//  TellMe
//
//  Created by Juncheng Han on 11/19/16.
//  Copyright © 2016 Juncheng Han. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PubNub/PubNub.h>

typedef void(^SendCompletion)(BOOL seccuss, NSString *error);

@interface StoreHelper : NSObject

+ (instancetype)shareInstance;

- (NSArray *)getStoredOkayArray;
- (NSArray *)getStoredNotOkayArray;

- (void)setOkayArray:(NSArray *)okayArray;
- (void)setNotOkayArray:(NSArray *)notOkayArray;

- (void)sendWithCompletion:(SendCompletion)completion;

@end

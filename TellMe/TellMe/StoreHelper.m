//
//  StoreHelper.m
//  TellMe
//
//  Created by Juncheng Han on 11/19/16.
//  Copyright © 2016 Juncheng Han. All rights reserved.
//

#import "StoreHelper.h"

@interface StoreHelper ()

@property (nonatomic, strong) PubNub *client;

@end

@implementation StoreHelper

- (instancetype)init {
    self = [super init];

    if (self) {
        
        PNConfiguration *configuration = [PNConfiguration configurationWithPublishKey:@"pub-c-4a0cff7d-24e0-4af6-8cda-64cea4bcf4e3"
                                                                         subscribeKey:@"sub-c-08f48a9a-ae8d-11e6-9ab5-0619f8945a4f"];
        self.client = [PubNub clientWithConfiguration:configuration];
    
        [self.client addListener:self];
        [self.client subscribeToChannels: @[@"dataManager"] withPresence:NO];
    }
    return self;
}

+ (instancetype)shareInstance {
    static StoreHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[StoreHelper alloc] init];
    });
    return instance;
}

- (void)setOkayArray:(NSArray *)okayArray {
    [[NSUserDefaults standardUserDefaults] setObject:okayArray forKey:@"OkayThing"];
}

- (NSArray *)getStoredOkayArray {
    NSArray *array = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"OkayThing"]];
    return array;
}

- (void)setNotOkayArray:(NSArray *)notOkayArray {
    [[NSUserDefaults standardUserDefaults] setObject:notOkayArray forKey:@"NotOkayThing"];
}

- (NSArray *)getStoredNotOkayArray {
    NSArray *array = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"NotOkayThing"]];
    return array;
}


- (void)sendWithCompletion:(SendCompletion)completion {
    // create the JSON file
    NSArray *okayArray = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"OkayThing"]];
    NSArray *notOkayArray = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"NotOkayThing"]];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:okayArray, @"OkayThings", notOkayArray, @"NotOkayThings", nil];
    
    NSError *error = nil;
    NSData *json;
    
    NSString *JSONString;
    
    // Dictionary convertable to JSON ?
    if ([NSJSONSerialization isValidJSONObject:dictionary]) {
        json = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
        if (json != nil && error == nil) {
            JSONString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            NSLog(@"JSON: %@", JSONString);
        }
    }
    
    [self.client publish:dictionary toChannel:@"dataManager" withCompletion:^(PNPublishStatus * _Nonnull status) {
        if (!status.isError) {
            NSLog(@"The dictionary is good");
            
            if (completion) {
                completion(YES, nil);
            }
        }
        else {
            NSLog(@"error: %@", status.errorData.information);
            
            if (completion) {
                completion(NO, status.errorData.information);
            }
        }
    }];
    
}



@end

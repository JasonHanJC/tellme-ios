//
//  StoreHelper.m
//  TellMe
//
//  Created by Juncheng Han on 11/19/16.
//  Copyright © 2016 Juncheng Han. All rights reserved.
//

#import "StoreHelper.h"

@interface StoreHelper ()


@end

@implementation StoreHelper

- (instancetype)init {
    self = [super init];

    if (self) {
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
    NSMutableDictionary *dicitonary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:okayArray, @"OkayThings", notOkayArray, @"NotOkayThings", nil];
    
    NSError *error = nil;
    NSData *json;
    
    // Dictionary convertable to JSON ?
    if ([NSJSONSerialization isValidJSONObject:dicitonary]) {
        json = [NSJSONSerialization dataWithJSONObject:dicitonary options:NSJSONWritingPrettyPrinted error:&error];
        if (json != nil && error == nil) {
            NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            
            NSLog(@"JSON: %@", jsonString);
        }
    }
    
    
    
}



@end

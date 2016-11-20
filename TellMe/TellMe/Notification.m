//
//  Notification.m
//  TellMe
//
//  Created by Juncheng Han on 11/20/16.
//  Copyright © 2016 Juncheng Han. All rights reserved.
//

#import "Notification.h"

@implementation Notification

- (id)init {
    self = [super init];
    if (self) {
        self.text = @"";
        self.date = [NSDate date];
        self.imageURL = @"";
    }
    return self;
}

@end

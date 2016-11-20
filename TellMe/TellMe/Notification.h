//
//  Notification.h
//  TellMe
//
//  Created by Juncheng Han on 11/20/16.
//  Copyright © 2016 Juncheng Han. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject

@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSDate *date;

@end

//
//  AppDelegate.h
//  TellMe
//
//  Created by Juncheng Han on 11/19/16.
//  Copyright © 2016 Juncheng Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PubNub/PubNub.h>
#import <UserNotifications/UserNotifications.h>
#import "AppDefines.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) PubNub *client;

@end


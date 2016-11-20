//
//  AppDelegate.m
//  TellMe
//
//  Created by Juncheng Han on 11/19/16.
//  Copyright © 2016 Juncheng Han. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch
    
    // custom the appearance for the navigation bar and tab bar
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.48 green:0.67 blue:0.90 alpha:1.0]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
    [UIColor whiteColor], NSForegroundColorAttributeName,
      [UIFont fontWithName:@"IndieFlower" size:30.0], NSFontAttributeName,nil]];
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:0.48 green:0.67 blue:0.90 alpha:1.0]];
    
    
    
    PNConfiguration *configuration = [PNConfiguration configurationWithPublishKey:PUBNUB_PUBLISH_KEY
                                                                     subscribeKey:PUBNUB_SUBSCRIBE_KEY];
    self.client = [PubNub clientWithConfiguration:configuration];
    
    [self.client addListener:self];
    [self.client subscribeToChannels:@[@"dataManager"] withPresence:NO];
    

    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];  
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {

}


- (void)applicationDidEnterBackground:(UIApplication *)application {

}


- (void)applicationWillEnterForeground:(UIApplication *)application {

}


- (void)applicationDidBecomeActive:(UIApplication *)application {

}


- (void)applicationWillTerminate:(UIApplication *)application {
}

#pragma mark - userNotification delegate
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    //Called when a notification is delivered to a foreground app.
    
    NSLog(@"Userinfo %@",notification.request.content.userInfo);
    
    completionHandler(UNNotificationPresentationOptionAlert);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    //Called to let your app know which action was selected by the user for a given notification.
    
    NSLog(@"Userinfo %@",response.notification.request.content.userInfo);
    
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [self.client addPushNotificationsOnChannels:@[@"dataManager"] withDevicePushToken:deviceToken andCompletion:^(PNAcknowledgmentStatus * _Nonnull status) {
        if (!status.isError) {
            
            // Handle successful push notification enabling on passed channels.
            NSLog(@"add the device to the channel");
        }
        else {
            NSLog(@"failure add the device to the channel");
            /**
             Handle modification error. Check 'category' property
             to find out possible reason because of which request did fail.
             Review 'errorData' property (which has PNErrorData data type) of status
             object to get additional information about issue.
             
             Request can be resent using: [status retry];
             */
        }
    }];
}

#pragma mark - pubnub delegate
- (void)client:(PubNub *)client didReceiveStatus:(PNStatus *)status {
   
}

// Handle new message from one of channels on which client has been subscribed.
- (void)client:(PubNub *)client didReceiveMessage:(PNMessageResult *)message {
    
    // Handle new message stored in message.data.message
    if (![message.data.channel isEqualToString:message.data.subscription]) {
        
        // Message has been received on channel group stored in message.data.subscription.
    }
    else {
        
        // Message has been received on channel stored in message.data.channel.
    }
    
    NSLog(@"Received message: %@ on channel %@ at %@", message.data.message,
          message.data.channel, message.data.timetoken);
}

@end

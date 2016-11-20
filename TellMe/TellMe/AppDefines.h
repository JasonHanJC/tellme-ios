//
//  AppDefines.h
//  TellMe
//
//  Created by Juncheng Han on 11/19/16.
//  Copyright © 2016 Juncheng Han. All rights reserved.
//

#ifndef AppDefines_h
#define AppDefines_h

// block self
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

// app UI define
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define PUBNUB_PUBLISH_KEY @"pub-c-4a0cff7d-24e0-4af6-8cda-64cea4bcf4e3"
#define PUBNUB_SUBSCRIBE_KEY @"sub-c-08f48a9a-ae8d-11e6-9ab5-0619f8945a4f"

#endif /* AppDefines_h */

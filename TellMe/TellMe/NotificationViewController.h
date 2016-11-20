//
//  NotificationViewController.h
//  TellMe
//
//  Created by Juncheng Han on 11/19/16.
//  Copyright © 2016 Juncheng Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PubNub/PubNub.h>

@interface NotificationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *talkButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *talkBtnBottomCN;

@property (nonatomic, strong) PubNub *client;

@end

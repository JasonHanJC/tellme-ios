//
//  NotificationViewController.m
//  TellMe
//
//  Created by Juncheng Han on 11/19/16.
//  Copyright © 2016 Juncheng Han. All rights reserved.
//

#import "NotificationViewController.h"
#import "UIImage+Cache.h"
#import "Notification.h"
#import "AppDefines.h"
#import "StoreHelper.h"

@interface NotificationViewController ()
@property (nonatomic, assign) CGPoint lastContentOffset;
@property (nonatomic, assign) BOOL isHiding;
@property (nonatomic, assign) CGFloat orignialY;
@property (nonatomic, assign) CGFloat lowestY;

@property (nonatomic, strong) NSMutableArray *dummyData;
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PNConfiguration *configuration = [PNConfiguration configurationWithPublishKey:PUBNUB_PUBLISH_KEY
                                                                     subscribeKey:PUBNUB_SUBSCRIBE_KEY];
    self.client = [PubNub clientWithConfiguration:configuration];
    
    [self.client addListener:self];
    [self.client subscribeToChannels:@[@"dataManager"] withPresence:NO];

    
    Notification *dummyNoti_1 = [[Notification alloc] init];
    dummyNoti_1.text = @"TEST";
    dummyNoti_1.imageURL = @"http://www.w3schools.com/css/trolltunga.jpg";
    
    Notification *dummyNoti_2 = [[Notification alloc] init];
    dummyNoti_2.text = @"TEST";
    dummyNoti_2.imageURL = @"http://www.w3schools.com/css/trolltunga.jpg";
    
    self.orignialY  = self.talkBtnBottomCN.constant;
    self.lowestY  = self.orignialY - 80;
    
    self.isHiding = false;
    
    self.dummyData = [NSMutableArray arrayWithArray:@[dummyNoti_1, dummyNoti_2]];
    
    self.talkButton.layer.cornerRadius = 30.0;
    // Shadow and Radius
    self.talkButton.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f] CGColor];
    self.talkButton.layer.shadowOffset = CGSizeMake(.9f, .9f);
    self.talkButton.layer.shadowOpacity = 1.0f;
    self.talkButton.layer.shadowRadius = 0.0f;
    self.talkButton.layer.masksToBounds = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dummyData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationIdentifier"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NotificationIdentifier"];
    }
    
    CGFloat imageSize = 50;
    UIGraphicsBeginImageContext(CGSizeMake(imageSize, imageSize));
    [[UIImage imageNamed:@"Notification"] drawInRect:CGRectMake(0, 0, imageSize, imageSize)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    cell.imageView.image = newImage;
    
    Notification *curNotification = self.dummyData[indexPath.row];
    
    [UIImage getImageWithURL:curNotification.imageURL completion:^(BOOL seccess, UIImage *image) {
        if (seccess) {
            CGFloat imageW = 50.0;
            CGFloat imageH = image.size.height / image.size.width * 50.0;
            UIGraphicsBeginImageContext(CGSizeMake(imageW, imageH));
            [image drawInRect:CGRectMake(0, 0, imageW, imageH)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            cell.imageView.image = newImage;
        }
    }];
    
    cell.textLabel.text = curNotification.text;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss dd-MM-yyyy"];
    cell.detailTextLabel.text = [dateFormatter stringFromDate:curNotification.date];
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _lastContentOffset = self.tableView.contentOffset;
}

- (IBAction)goToMessage:(UIButton *)sender {
    [self performSegueWithIdentifier:@"dummyMessage" sender:nil];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_isHiding) {
        _isHiding = !_isHiding;
    if (_lastContentOffset.y < scrollView.contentOffset.y) {
        if (self.talkBtnBottomCN.constant == _orignialY)
            self.talkBtnBottomCN.constant -= 80;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

            [self.view layoutIfNeeded];
            
        } completion:nil];
    }
    
    else if (_lastContentOffset.y > scrollView.contentOffset.y) {
        if (self.talkBtnBottomCN.constant == _lowestY)
            self.talkBtnBottomCN.constant += 80;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [self.view layoutIfNeeded];
        } completion:nil];
    }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _isHiding = !_isHiding;
}


- (IBAction)deletenotifications:(UIBarButtonItem *)sender {
    
    [self.dummyData removeAllObjects];
    
    [self.tableView reloadData];
    
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
    
    if (![message.data.message isKindOfClass:[NSDictionary class]]) {
        if ([message.data.message isKindOfClass:[NSArray class]]) {
            NSArray *messageArray = message.data.message;
            NSString *url = messageArray[messageArray.count - 1];
            for(int i = 0; i < messageArray.count - 1; i++) {
                NSString *str = messageArray[i];
                if ([self needShow:str]) {
                
                    Notification *newNoti = [[Notification alloc] init];
        
                    newNoti.text = str;
                    newNoti.imageURL = url;
                    [self.dummyData insertObject:newNoti atIndex:0];
                    [UIView transitionWithView: self.tableView
                                      duration: 0.35f
                                       options: UIViewAnimationOptionTransitionCrossDissolve
                                    animations: ^(void)
                     {
                         [self.tableView reloadData];
                     }
                                    completion: nil];
                }
            }
        }
    }
    NSLog(@"Received message: %@ on channel %@ at %@", message.data.message, message.data.channel, message.data.timetoken);
}

- (BOOL)needShow:(NSString *)test {
    
    if ([[[StoreHelper shareInstance] getStoredNotOkayArray] containsObject:test]) {
        return true;
    }
    
    if ([[[StoreHelper shareInstance] getStoredOkayArray] containsObject:test]) {
        return false;
    }
    
    return false;
}
@end

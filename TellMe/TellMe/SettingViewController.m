//
//  SettingViewController.m
//  TellMe
//
//  Created by Juncheng Han on 11/19/16.
//  Copyright © 2016 Juncheng Han. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@property (nonatomic, strong, readonly) NSArray *settingArray;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _settingArray = @[@"Send Email", @"Push Notification"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.scrollEnabled = NO;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.settingArray)
        return self.settingArray.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingIdentifier"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingIdentifier"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    cell.accessoryView = switchView;
    [switchView setOn:NO animated:NO];
    [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    cell.textLabel.text = self.settingArray[indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Change Notification Rule";
}

- (void)switchChanged:(UISwitch *)sender {
    
}
@end

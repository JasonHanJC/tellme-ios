//
//  NotOkayViewController.m
//  TellMe
//
//  Created by Juncheng Han on 11/19/16.
//  Copyright © 2016 Juncheng Han. All rights reserved.
//

#import "NotOkayViewController.h"
#import "AppDefines.h"
#import "StoreHelper.h"
#import "UIView+Toast.h"

@interface NotOkayViewController ()

@property (nonatomic, strong) NSMutableArray *notOkayArray;

@end

@implementation NotOkayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.updateButton setEnabled:NO];
    
    if ([[StoreHelper shareInstance] getStoredNotOkayArray]) {
        self.notOkayArray = [NSMutableArray arrayWithArray:[[StoreHelper shareInstance] getStoredNotOkayArray]];
    } else {
        self.notOkayArray = [[NSMutableArray alloc] init];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source and delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.notOkayArray) {
        return 0;
    }
    return self.notOkayArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotOkayIdentifier"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NotOkayIdentifier"];
    }
    UIButton *changeSettingBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    changeSettingBtn.frame = CGRectMake(0, 0, 30, 30);
    [changeSettingBtn setImage:[UIImage imageNamed:@"Setting"] forState:UIControlStateNormal];
    changeSettingBtn.tag = indexPath.row;
    [changeSettingBtn addTarget:self action:@selector(editNotificationRule:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.accessoryView = changeSettingBtn;
    cell.imageView.image = [UIImage imageNamed:@"NOkay"];
    cell.textLabel.text = self.notOkayArray[indexPath.row];
    
    return cell;
}

- (void)editNotificationRule:(UIButton *)sender {
    [self performSegueWithIdentifier:@"ChangeNotificationRule" sender:[NSNumber numberWithLong:sender.tag]];
}

- (IBAction)addNotOkayThing:(UIBarButtonItem *)sender {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Add bad things"
                                                                              message: nil
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Thing name";
        textField.textColor = [UIColor blackColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    
    WEAKSELF
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField *thingName = textfields[0];
        NSString *name = [thingName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([name isEqualToString:@""] || name == nil)
            return;
        [weakSelf.notOkayArray addObject:name];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self anyChange])
                [self.updateButton setEnabled:YES];
            [weakSelf.tableView reloadData];
        });
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //NSLog(@"%ld", (long)indexPath.row);
        
        [weakSelf.notOkayArray removeObject:weakSelf.notOkayArray[indexPath.row]];
        if ([self anyChange])
            [self.updateButton setEnabled:YES];
        [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [weakSelf.tableView setEditing:NO];
    }];
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        [weakSelf editinhThingAtIndex:indexPath.row];
        [weakSelf.tableView setEditing:NO];
    }];
    
    return @[deleteAction, editAction];
}

- (void)editinhThingAtIndex:(NSInteger)index {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Edit"
                                                                              message: nil
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"New name";
        textField.textColor = [UIColor blackColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    
    WEAKSELF
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField *thingName = textfields[0];
        [weakSelf.notOkayArray removeObjectAtIndex:index];
        [weakSelf.notOkayArray insertObject:thingName.text atIndex:index];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self anyChange])
                [self.updateButton setEnabled:YES];
            [weakSelf.tableView reloadData];
        });
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)update:(UIBarButtonItem *)sender {
    
    [[StoreHelper shareInstance] setNotOkayArray:[NSArray arrayWithArray:self.notOkayArray]];
    [[StoreHelper shareInstance] sendWithCompletion:^(BOOL success, NSString *error){
        NSString *toastMsg;
        if (success) {
            toastMsg = @"Update Success";
            [self.updateButton setEnabled:NO];
        } else {
            toastMsg = error;
        }
        
        [self.view makeToast:toastMsg duration:1.0 position:[NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0 + 200)]];
    }];
}

- (BOOL)anyChange {
    NSArray *curOkayArray = [NSArray arrayWithArray:self.notOkayArray];
    
    if ([curOkayArray isEqual:[[StoreHelper shareInstance] getStoredNotOkayArray]]) {
        return NO;
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end

//
//  OkayTableViewController.m
//  TellMe
//
//  Created by Juncheng Han on 11/19/16.
//  Copyright © 2016 Juncheng Han. All rights reserved.
//

#import "OkayTableViewController.h"
#import "AppDefines.h"
#import "StoreHelper.h"

@interface OkayTableViewController ()

@property (nonatomic, strong) NSMutableArray *okayThingArray;

@end

@implementation OkayTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    
    if ([[StoreHelper shareInstance] getStoredOkayArray]) {
        self.okayThingArray = [NSMutableArray arrayWithArray:[[StoreHelper shareInstance] getStoredOkayArray]];
    } else {
        self.okayThingArray = [[NSMutableArray alloc] init];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source and delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.okayThingArray)
        return self.okayThingArray.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OkayThingIdentifier"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OkayThingIdentifier"];
     }
    
    cell.textLabel.text = self.okayThingArray[indexPath.row];
    
    return cell;
}

- (IBAction)addOkayThing:(UITabBarItem *)sender {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Add okay things"
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
        UITextField *thingNameFld = textfields[0];
        NSString *name = [thingNameFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([name isEqualToString:@""] || name == nil)
             return;
        [weakSelf.okayThingArray addObject:name];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //NSLog(@"%ld", (long)indexPath.row);
        
        [weakSelf.okayThingArray removeObject:weakSelf.okayThingArray[indexPath.row]];
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
        [weakSelf.okayThingArray removeObjectAtIndex:index];
        [weakSelf.okayThingArray insertObject:thingName.text atIndex:index];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)update:(UIBarButtonItem *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:self.okayThingArray] forKey:@"OkayThing"];
    NSLog(@"%@", self.okayThingArray);
    NSLog(@"%@", [[StoreHelper shareInstance] getStoredOkayArray]);
    
    [[StoreHelper shareInstance] sendWithCompletion:nil];
}

@end

//
//  OkayViewController.m
//  TellMe
//
//  Created by Juncheng Han on 11/19/16.
//  Copyright © 2016 Juncheng Han. All rights reserved.
//

#import "OkayViewController.h"
#import "AppDefines.h"
#import "StoreHelper.h"
#import "UIView+Toast.h"

@interface OkayViewController ()

@property (nonatomic, strong) NSMutableArray *okayThingArray;

@end

@implementation OkayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.updateButton setEnabled:NO];
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
    
    cell.imageView.image = [UIImage imageNamed:@"Okay"];
    cell.textLabel.text = self.okayThingArray[indexPath.row];
    
    return cell;
}

- (IBAction)addOkayThing:(UIBarButtonItem *)sender {
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
            if ([weakSelf anyChange])
                [weakSelf.updateButton setEnabled:YES];
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
        if ([self anyChange])
            [self.updateButton setEnabled:YES];
        [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [weakSelf.tableView setEditing:NO];
    }];
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        [weakSelf editingThingAtIndex:indexPath.row];
        [weakSelf.tableView setEditing:NO];
    }];
    
    return @[deleteAction, editAction];
}

- (void)editingThingAtIndex:(NSInteger)index {
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
        UITextField *thingNameFld = textfields[0];
        NSString *name = [thingNameFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [weakSelf.okayThingArray removeObjectAtIndex:index];
        [weakSelf.okayThingArray insertObject:name atIndex:index];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([weakSelf anyChange])
                [weakSelf.updateButton setEnabled:YES];
            [weakSelf.tableView reloadData];
        });
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)update:(UIBarButtonItem *)sender {
    [[StoreHelper shareInstance] setOkayArray:[NSArray arrayWithArray:self.okayThingArray]];
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
    NSArray *curOkayArray = [NSArray arrayWithArray:self.okayThingArray];
    
    if ([curOkayArray isEqual:[[StoreHelper shareInstance] getStoredOkayArray]]) {
        return NO;
    }
    return YES;
}


@end

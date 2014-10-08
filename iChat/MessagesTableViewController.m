//
//  MessagesTableViewController.m
//  iChat
//
//  Created by Florian BUREL on 07/10/2014.
//  Copyright (c) 2014 Florian Burel. All rights reserved.
//

#import "MessagesTableViewController.h"

#import "MessagesListViewModel.h"

#import "Message.h"
#import "User.h"
#import "SimpleServiceLocator.h"


@interface MessagesTableViewController ()

@property (readonly) MessagesListViewModel * viewModel;

@end

@implementation MessagesTableViewController

- (MessagesListViewModel *)viewModel
{
    return [[SimpleServiceLocator sharedInstance]serviceWithType:[MessagesListViewModel class]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self.viewModel
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.viewModel refresh];
    
    [self.navigationController setToolbarHidden:NO];

}

- (void)viewWillAppear:(BOOL)animated
{
    [self.viewModel addObserver:self
                     forKeyPath:@"isBusy"
                        options:0 context:NULL];

}

- (void)viewWillDisappear:(BOOL)animated
{
    @try {
    [self.viewModel removeObserver:self forKeyPath:@"isBusy"];
    }
    @catch (NSException *exception) {
    }
}
- (IBAction)composeButtonPressed:(id)sender {
    
    NSString * title = NSLocalizedString(@"Entrer your text here", nil);
    
    UIAlertController * alert;
    alert = [UIAlertController alertControllerWithTitle:title
                                                message:nil
                                         preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = title;
    }];
    
    NSString * sendButtonTitle = NSLocalizedString(@"send", nil);
    UIAlertAction * sendAction = [UIAlertAction actionWithTitle:sendButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField * textField = alert.textFields.firstObject;
        self.viewModel.text = textField.text;
        [self.viewModel send];
    }];
    
    NSString * cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:sendAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
   
}

#pragma mark - busy indication

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(object == self.viewModel && [keyPath isEqualToString:@"isBusy"])
    {
        [self busyStatusChanged];
    }
}

- (void) busyStatusChanged
{
    if(self.viewModel.isBusy)
    {
        self.title = NSLocalizedString(@"Loading...", nil);
    }
    else
    {
        self.title = NSLocalizedString(@"Messages", nil);
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.viewModel.messages.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Message * message = self.viewModel.messages[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = message.text;
    cell.detailTextLabel.text = message.sender.name;
    return cell;
}

@end

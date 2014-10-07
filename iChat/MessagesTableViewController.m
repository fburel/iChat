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

@interface MessagesTableViewController ()

@property (strong, nonatomic) MessagesListViewModel * viewModel;

@end

@implementation MessagesTableViewController

- (MessagesListViewModel *)viewModel
{
    if(!_viewModel)
    {
        _viewModel = [[MessagesListViewModel alloc]initWithConversation:self.conversation];
        
    }
    return _viewModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.viewModel addObserver:self
                     forKeyPath:@"isBusy"
                        options:0 context:NULL];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self.viewModel
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.viewModel refresh];
    
    [self.navigationController setToolbarHidden:NO];

}

- (IBAction)composeButtonPressed:(id)sender {
    
   
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

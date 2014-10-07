//
//  UsersTableViewController.m
//  iChat
//
//  Created by Florian BUREL on 07/10/2014.
//  Copyright (c) 2014 Florian Burel. All rights reserved.
//

#import "UsersTableViewController.h"
#import "ChatService.h"
#import "User.h"

@interface UsersTableViewController ()

@property (strong, nonatomic) NSArray * users;
@property (strong, nonatomic) NSMutableArray * selectedUsers;


@end

@implementation UsersTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    ChatService * service = [ChatService sharedInstance];
    [service fetchAllUsers:^(NSArray *results, NSError *error) {
        self.users = results;
        if(error)
        {
            // deal with error
        }
        else
        {
            [self.tableView reloadData];
        }
        
    }];
}

- (IBAction)doneButtonPressed:(id)sender
{
    [self.delegate usersTableViewController:self
                             didSelectUsers:[self.selectedUsers copy]];
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [self.delegate usersTableViewController:self
                             didSelectUsers:nil];
}

- (NSMutableArray *)selectedUsers
{
    if(!_selectedUsers)
    {
        _selectedUsers = [NSMutableArray new];
    }
    return _selectedUsers;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.users.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    User * user = self.users[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = user.name;
    
    // affiche la checkmark si l'utilisateur est selectionné
    BOOL userIsAlreadySelected = [self.selectedUsers containsObject:user];
    
    if(userIsAlreadySelected)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User * user = self.users[indexPath.row];
    
    if([self.selectedUsers containsObject:user])
    {
        [self.selectedUsers removeObject:user];
    }
    else
    {
        [self.selectedUsers addObject:user];
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

@end

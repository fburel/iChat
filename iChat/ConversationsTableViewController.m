//
//  ConversationsTableViewController.m
//  iChat
//
//  Created by Florian BUREL on 07/10/2014.
//  Copyright (c) 2014 Florian Burel. All rights reserved.
//

#import "ConversationsTableViewController.h"
#import "ChatService.h"
#import <Parse/Parse.h>
#import "UsersTableViewController.h"
#import "ConversationsListviewModel.h"
#import "Conversation.h"
#import "MessagesTableViewController.h"


@interface ConversationsTableViewController()
<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UsersTableViewControllerDelegate>

@property (strong, nonatomic) ConversationsListviewModel * viewModel;

@end

@implementation ConversationsTableViewController

- (ConversationsListviewModel *)viewModel
{
    if(!_viewModel)
    {
        _viewModel = [ConversationsListviewModel sharedInstance];
    }
    return _viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self.viewModel
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    
    
    }

- (void)viewWillAppear:(BOOL)animated
{
    [self.viewModel addObserver:self
                     forKeyPath:@"isBusy"
                        options:0 context:NULL];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    @try
    {
        [self.viewModel removeObserver:self forKeyPath:@"isBusy"];
    }
    @catch(NSError * e)
    {
        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if(self.viewModel.userIsLogged)
    {
        [self.viewModel refresh];
    }
    else
    {
        [self presentLogginScreen];
    }

}
- (void) presentLogginScreen
{
    // Create the log in view controller
    PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    
    logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten;
    
    
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Create the sign up view controller
    PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Assign our sign up controller to be displayed from the login controller
    [logInViewController setSignUpController:signUpViewController];
    
    // Present the log in view controller
    [self presentViewController:logInViewController animated:YES completion:NULL];
}


#pragma mark - Login & SignUp 

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [self userDidLog:user];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    [self userDidLog:user];
}

- (void) userDidLog:(PFUser *)user
{
    // enregistre l'utilisateur aupres de notre service local
    [self.viewModel logParseUser:user];
    
    // Masque l'ecran login
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.viewModel refresh];
}


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
        self.title = NSLocalizedString(@"Conversations", nil);
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
    return self.viewModel.conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Conversation * c = self.viewModel.conversations[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [c title];
    cell.detailTextLabel.text = [c subtitle];
    
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"SELECT_USERS"])
    {
        UsersTableViewController * tv = segue.destinationViewController;
        
        tv.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"DETAIL_SEGUE"])
    {
        NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
        
        Conversation * c = self.viewModel.conversations[indexPath.row];
        
        self.viewModel.selectedConversation = c;
        
    }
}


#pragma mark - UsersTableViewcontrollerDelegate

- (void)usersTableViewController:(id)sender didSelectUsers:(NSArray *)users
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if(users != nil && users.count != 0)
    {
        [self.viewModel createConversationInBackground:users];
    }
}

@end

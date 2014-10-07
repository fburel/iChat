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

@interface ConversationsTableViewController()
<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UsersTableViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray * conversations;

@end

@implementation ConversationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ChatService * service = [ChatService sharedInstance];
    
    BOOL userIsLogged = (service.currentUser != nil);
    
    if(userIsLogged)
    {
       
    }
    else
    {
        [self presentLogginScreen];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    ChatService * service = [ChatService sharedInstance];
    service.currentUser = user;
    
    // Masque l'ecran login
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // TEMPORAIRE : afficher dans la navBar le nom de l'user
    self.title = user.username;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = @"toto";
    
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
}


#pragma mark - UsersTableViewcontrollerDelegate

- (void)usersTableViewController:(id)sender didSelectUsers:(NSArray *)users
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if(users != nil && users.count != 0)
    {
        ChatService * service = [ChatService sharedInstance];
        [service createConversationWithUsers:users
                                  completion:^(NSArray *results, NSError *error)
        {
            if(!error)
            {
                [self.conversations addObject:results[0]];
                [self.tableView reloadData];
            }
        }];
    }
}

- (NSMutableArray *)conversations
{
    if(!_conversations)
    {
        _conversations = [NSMutableArray new];
    }
    return _conversations;
}
@end

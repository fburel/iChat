//
//  UsersTableViewController.h
//  iChat
//
//  Created by Florian BUREL on 07/10/2014.
//  Copyright (c) 2014 Florian Burel. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol UsersTableViewControllerDelegate <NSObject>

- (void) usersTableViewController:(id)sender didSelectUsers:(NSArray *)users;

@end

@interface UsersTableViewController : UITableViewController

@property (weak, nonatomic) id<UsersTableViewControllerDelegate> delegate;

@end

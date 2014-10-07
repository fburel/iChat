//
//  MessageListViewModel.h
//  iChat
//
//  Created by Florian BUREL on 07/10/2014.
//  Copyright (c) 2014 Florian Burel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Conversation;
@class PFUser;

@interface MessageListViewModel : NSObject

@property (readonly) BOOL userIsLogged;

- (void) logParseUser:(PFUser *)user;

// Indique si on execute une tache en arriere plan
@property (readonly, assign, nonatomic) BOOL isBusy;

// Stocke la liste des conversation
@property (readonly, strong, nonatomic) NSArray * conversations;

- (void) refresh;

- (void) createConversationInBackground:(NSArray *)users;

@end

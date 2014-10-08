//
//  MessageListViewModel.h
//  iChat
//
//  Created by Florian BUREL on 07/10/2014.
//  Copyright (c) 2014 Florian Burel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Conversation.h"

@class PFUser;

@interface ConversationsListviewModel : NSObject

+ (instancetype) sharedInstance;

@property (readonly) BOOL userIsLogged;

- (void) logParseUser:(PFUser *)user;

// Indique si on execute une tache en arriere plan
@property (readonly, assign, nonatomic) BOOL isBusy;

// Stocke la liste des conversation
@property (readonly, strong, nonatomic) NSArray * conversations;

@property (strong, nonatomic) Conversation * selectedConversation;

- (void) refresh;

- (void) createConversationInBackground:(NSArray *)users;


@end


@interface Conversation (Display)

- (NSString *) title;

- (NSString *) subtitle;

@end

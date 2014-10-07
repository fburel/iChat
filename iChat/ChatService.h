//
//  ChatService.h
//  iChat
//
//  Created by Florian BUREL on 07/10/2014.
//  Copyright (c) 2014 Florian Burel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PFUser;
@class Conversation;
@class Message;

typedef void(^FetchedResultBlock)(NSArray * results, NSError * error);

@interface ChatService : NSObject

// Singleton
+ (instancetype) sharedInstance;

// le PFUser loggé
@property (strong, nonatomic) PFUser * currentUser;

// Recupere la liste des conversations de l'utilisateur
- (void) fetchConversations:(FetchedResultBlock)completion;

// Cree une nouvelle conversation
- (void) createConversationWithUsers:(NSArray *)users completion:(FetchedResultBlock)completion;

// Ajoute un message a une conversation
- (void) sendMessage:(Message *)message toConversation:(Conversation *)conversation completion:(FetchedResultBlock)completion;

// Recupere les message d'une conversation
- (void) fetchMessagesForConversation:(Conversation *)conversation completion:(FetchedResultBlock)completion;

// Recupere la liste des utilisateurs
- (void) fetchAllUsers:(FetchedResultBlock)completion;

@end

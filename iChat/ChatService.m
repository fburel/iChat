//
//  ChatService.m
//  iChat
//
//  Created by Florian BUREL on 07/10/2014.
//  Copyright (c) 2014 Florian Burel. All rights reserved.
//

#import "ChatService.h"
#import <Parse/Parse.h>
#import "User.h"
#import "Conversation.h"
#import "Message.h"

#define APPLICATION_ID      @"WJzllICtcRTPm2HffXrfhTmrukaWjq0HGmxBamLh"
#define CLIENT_KEY          @"4hibUxC3WCLP0Yy62RZ5hKVciSVOFSwldB5G02gG"



@implementation ChatService

+ (instancetype)sharedInstance
{
    static id __SharedInstance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        __SharedInstance = [[self alloc] init];
    });
    
    return __SharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [Parse setApplicationId:APPLICATION_ID
                      clientKey:CLIENT_KEY];
        
        
    }
    return self;
}

- (NSArray *) parsePFUsers:(NSArray *)objects
{
    // parser les resultats
    NSMutableArray * users = [[NSMutableArray alloc]init];
    
    for (PFUser * item in objects)
    {
        User * newUser = [[User alloc]init];
        newUser.name = item.username;
        newUser.identifier = item.objectId;
        newUser.url = item[@"photoUrl"];
        
        [users addObject:newUser];
    }

    return [users copy];
}

- (void)fetchAllUsers:(FetchedResultBlock)completion
{
    PFQuery * query = [PFUser query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            
            completion([self parsePFUsers:objects], nil);
        }
        else
        {
            // retourner l'erreur
            completion(nil, error);
        }
    }];
}

- (void)fetchConversations:(FetchedResultBlock)completion
{
    PFQuery * query = [PFQuery queryWithClassName:@"Conversations"];
    [query whereKey:@"users" containsAllObjectsInArray:@[self.currentUser]];
    [query includeKey:@"users"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if(!error)
        {
            // parser les resultats
            NSMutableArray * conversations = [[NSMutableArray alloc]init];
            
            for (PFObject * item in objects)
            {
                Conversation * conversation = [Conversation new];
                conversation.creationDate = item.createdAt;
                conversation.identifier = item.objectId;
                conversation.users = [self parsePFUsers:item[@"users"]];
                
            }
            
            completion(conversations, nil);
        }
        else
        {
            // retourner l'erreur
            completion(nil, error);
        }
    }];
    
}

- (void)fetchMessagesForConversation:(Conversation *)conversation completion:(FetchedResultBlock)completion
{
    
    PFQuery * conversationQuery = [PFQuery queryWithClassName:@"Conversation"];
    [conversationQuery whereKey:@"objectId" equalTo:conversation.identifier];
    
    PFQuery * query = [PFQuery queryWithClassName:@"Message"];
    [query whereKey:@"conversation" matchesQuery:conversationQuery];
    [query includeKey:@"sender"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            NSMutableSet * messagesSet = [NSMutableSet new];
            
            for (PFObject * item in objects)
            {
                Message * message = [Message new];
                message.text = item[@"text"];
                message.sender = [self parsePFUsers:@[item[@"sender"]]][0];
                message.sentDate = item.createdAt;
                [messagesSet addObject:message];
            }
            
            NSSortDescriptor * sorter = [NSSortDescriptor sortDescriptorWithKey:@"sentDate" ascending:YES];
            
            NSArray * sortedMessages = [messagesSet sortedArrayUsingDescriptors:sorter];
            
            completion(sortedMessages, nil);
        }
        else
        {
            completion(nil, error);
        }
    }];
}



- (void)sendMessage:(Message *)message toConversation:(Conversation *)conversation completion:(FetchedResultBlock)completion
{
    PFObject * item = [PFObject objectWithClassName:@"Message"];
    item[@"text"] = message.text;
    item[@"sender"] = [PFObject objectWithoutDataWithClassName:@"Conversation"
                                                      objectId:conversation.identifier];
    [item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completion(@[@(succeeded)], error);
    }];
}



- (void)createConversationWithUsers:(NSArray *)users completion:(FetchedResultBlock)completion
{
    PFObject * item = [PFObject objectWithClassName:@"Conversation"];
    
    NSMutableArray * userArray = [NSMutableArray new];
    for (User * user in users) {
        id tempUser = [PFUser objectWithoutDataWithObjectId:user.identifier];
        [userArray addObject:tempUser];
    }
    
    [item addObjectsFromArray:userArray forKey:@"users"];
    
    [item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if(succeeded)
        {
            completion(@[@(succeeded)], nil);
        }
        else
        {
            completion(nil, error);
        }
    }];
    
    
}
@end

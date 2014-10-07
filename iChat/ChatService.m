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
        [Parse setApplicationId:@"hxCeOawMZ9ZNcZzJ5DJvQBBhE4f9siQjAFTuYsSJ"
                      clientKey:@"jpKyTk0NOp277m5jPw55DRFJ2CzF8F5pAsExzbL9"];
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
    
}



- (void)sendMessage:(Message *)message toConversation:(Conversation *)conversation completion:(FetchedResultBlock)completion
{
    
}



- (void)createConversationWithUsers:(NSArray *)users completion:(FetchedResultBlock)completion
{
    
}
@end

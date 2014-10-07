//
//  MessageListViewModel.m
//  iChat
//
//  Created by Florian BUREL on 07/10/2014.
//  Copyright (c) 2014 Florian Burel. All rights reserved.
//

#import "MessageListViewModel.h"
#import "ChatService.h"

@interface MessageListViewModel ()

@property (assign, nonatomic) BOOL isBusy;
@property (strong, nonatomic) NSArray * conversations;

@property (readonly) ChatService * service;

@end

@implementation MessageListViewModel

- (ChatService *)service
{
    return [ChatService sharedInstance];
}

- (NSArray *)conversations
{
    if(!_conversations)
    {
        _conversations = [[NSArray alloc]init];
    }
    return _conversations;
}

- (BOOL)userIsLogged
{
    return self.service.currentUser != nil;
}

- (void)logParseUser:(PFUser *)user
{
    self.service.currentUser = user;
}

- (void)refresh
{
    self.isBusy = YES;
    
    [self.service fetchConversations:^(NSArray *results, NSError *error) {
        self.conversations = results;
        self.isBusy = NO;
    }];
    
}

- (void)createConversationInBackground:(NSArray *)users
{
    self.isBusy = YES;
    
    
    [self.service createConversationWithUsers:users
                                   completion:^(NSArray *results, NSError *error)
     {
         [self refresh];
     }];
}

@end

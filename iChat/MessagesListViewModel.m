//
//  MessagesListViewModel.m
//  iChat
//
//  Created by Florian BUREL on 07/10/2014.
//  Copyright (c) 2014 Florian Burel. All rights reserved.
//

#import "MessagesListViewModel.h"

#import "ChatService.h"
#import "Message.h"
#import "ConversationsListviewModel.h"
#import "SimpleServiceLocator.h"

@interface MessagesListViewModel ()

@property (assign, nonatomic) BOOL isBusy;
@property (strong, nonatomic) NSArray * messages;
@property (readonly) Conversation * conversation;

@property (readonly) ChatService * service;

@end

@implementation MessagesListViewModel

- (Conversation *)conversation
{
    ConversationsListviewModel * vm = [[SimpleServiceLocator sharedInstance] serviceWithType:[ConversationsListviewModel class]];
    return vm.selectedConversation;
}

- (ChatService *)service
{
    return [[SimpleServiceLocator sharedInstance] serviceWithType:[ChatService class]];
}

- (NSArray *)messages
{
    if(!_messages)
    {
        _messages = [[NSArray alloc]init];
    }
    return _messages;
}


- (void)send;
{
    self.isBusy = YES;
    Message * m = [Message new];
    m.text = self.text;
    
    [self.service sendMessage:m
               toConversation:self.conversation
                   completion:^(NSArray *results, NSError *error)
    {
        [self refresh];
    }];
}

- (void)refresh
{
    self.isBusy = YES;
    [self.service fetchMessagesForConversation:self.conversation
                                    completion:^(NSArray *results, NSError *error)
    {
        self.messages = results;
        self.isBusy = NO;
    }];
}

@end

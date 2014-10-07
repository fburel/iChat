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

@interface MessagesListViewModel ()

@property (assign, nonatomic) BOOL isBusy;
@property (strong, nonatomic) NSArray * messages;
@property (strong, nonatomic) Conversation * conversation;

@property (readonly) ChatService * service;

@end

@implementation MessagesListViewModel

- (instancetype)initWithConversation:(Conversation *)conversation
{
    self = [super init];
    if (self) {
        self.conversation = conversation;
    }
    return self;
}

- (ChatService *)service
{
    return [ChatService sharedInstance];
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

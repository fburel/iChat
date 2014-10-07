//
//  MessagesListViewModel.h
//  iChat
//
//  Created by Florian BUREL on 07/10/2014.
//  Copyright (c) 2014 Florian Burel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Conversation;
@class Message;

@interface MessagesListViewModel : NSObject

- (instancetype) initWithConversation:(Conversation *)conversation;

@property (readonly) BOOL isBusy;
@property (strong, nonatomic) NSString * text;


@property (strong, readonly, nonatomic) NSArray * messages;
- (void) refresh;
- (void) send;

@end

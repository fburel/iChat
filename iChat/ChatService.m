//
//  ChatService.m
//  iChat
//
//  Created by Florian BUREL on 07/10/2014.
//  Copyright (c) 2014 Florian Burel. All rights reserved.
//

#import "ChatService.h"
#import <Parse/Parse.h>

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

- (void)sendMessage:(Message *)message toConversation:(Conversation *)conversation completion:(FetchedResultBlock)completion
{
    
}

- (void)fetchAllUsers:(FetchedResultBlock)completion
{
    
}

- (void)fetchConversations:(FetchedResultBlock)completion
{
    
}

- (void)fetchMessagesForConversation:(Conversation *)conversation completion:(FetchedResultBlock)completion
{
    
}

- (void)createConversationWithUsers:(NSArray *)users completion:(FetchedResultBlock)completion
{
    
}
@end

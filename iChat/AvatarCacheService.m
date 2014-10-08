//
//  AvatarCacheService.m
//  iChat
//
//  Created by Florian BUREL on 08/10/2014.
//  Copyright (c) 2014 Florian Burel. All rights reserved.
//

#import "AvatarCacheService.h"
#import "User.h"
#import "NSString+MD5.h"
#import "ICGravatarOperation.h"

@interface AvatarCacheService ()
@property (strong, nonatomic) NSOperationQueue * asyncQueue;
@end

@implementation AvatarCacheService

- (NSOperationQueue *)asyncQueue
{
    if(!_asyncQueue)
    {
        _asyncQueue = [NSOperationQueue new];
    }
    return _asyncQueue;
}
- (void)registerAvatar:(NSData *)avatarData forUser:(User *)user
{
   
    // Construction de l'url
    NSURL * url = [self urlForEmail:user.email];
    
    [avatarData writeToURL:url atomically:YES];
}

- (NSURL *) urlForEmail:(NSString *)email
{
    NSString * md5 = email.md5;
    NSString * fileName = [NSString stringWithFormat:@"%@.jpg", md5];
    NSFileManager * fm = [NSFileManager new];
    NSURL * url = [[fm URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
    return [url URLByAppendingPathComponent:fileName];
}

- (NSData *)avatarForUser:(User *)user
{
    NSURL * url = [self urlForEmail:user.email];
    return [NSData dataWithContentsOfURL:url];
}

- (void) downloadAvatarForUser:(User *)user completion:(dispatch_block_t)completion
{
    
    ICGravatarOperation * operation = [[ICGravatarOperation alloc]init];
    [operation setUser:user];
    
    NSBlockOperation * record = [NSBlockOperation blockOperationWithBlock:^{
        [self registerAvatar:operation.avatarData forUser:user];
    }];
    [record addDependency:operation];
    
    NSBlockOperation * cBlock = [NSBlockOperation blockOperationWithBlock:completion];
    [cBlock addDependency:record];
    
     [self.asyncQueue addOperation:operation];
    [self.asyncQueue addOperation:record];
    [[NSOperationQueue mainQueue]addOperation:cBlock];
    
}

@end

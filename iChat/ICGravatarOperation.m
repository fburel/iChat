//
//  ICGravatarOperation.m
//  iChat
//
//  Created by Florian BUREL on 08/10/2014.
//  Copyright (c) 2014 Florian Burel. All rights reserved.
//

#import "ICGravatarOperation.h"
#import "NSString+MD5.h"
#import "User.h"

#define BASE_URL @"http://www.gravatar.com/avatar/"

@implementation ICGravatarOperation

- (void)main
{
    
    NSString * hash = [self.user.email md5];
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, hash];
    
    NSURL * url = [NSURL URLWithString:urlString];
    
    self.avatarData =  [NSData dataWithContentsOfURL:url];
    
}


@end

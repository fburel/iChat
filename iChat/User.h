//
//  User.h
//  iChat
//
//  Created by Florian BUREL on 07/10/2014.
//  Copyright (c) 2014 Florian Burel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * identifier;
@property (strong, nonatomic) NSString * email;

@end

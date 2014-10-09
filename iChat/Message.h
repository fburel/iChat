//
//  Message.h
//  iChat
//
//  Created by Florian BUREL on 09/10/2014.
//  Copyright (c) 2014 Florian Burel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Message : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * sentDatte;
@property (nonatomic, retain) NSManagedObject *conversation;
@property (nonatomic, retain) NSManagedObject *sender;

@end

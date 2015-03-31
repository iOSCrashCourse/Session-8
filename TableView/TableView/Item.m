//
//  Item.m
//  TableView
//
//  Created by Janum Trivedi on 3/10/15.
//  Copyright (c) 2015 Janum Trivedi. All rights reserved.
//

#import "Item.h"

@implementation Item

- (instancetype)initWithTitle:(NSString *)title dateCreated:(NSDate *)date
{
    // Call this class's "super" init method (i.e., NSObject's init)
    if (self == [super init]) {
        // If successful, assign properties, etc.
        
        self.itemTitle = title;
        self.dateCreated = date;
    }
    
    // Return self, the new Item instance.
    return self;
}

// initWithCoder is called when we attempt to unarchive an object
- (id)initWithCoder:(NSCoder *)coder
{
    if (self == [super init]) {
        self.itemTitle = [coder decodeObjectForKey:@"itemTitle"];
        self.dateCreated = [coder decodeObjectForKey:@"dateCreated"];
        self.completed = [coder decodeBoolForKey:@"completed"];
    }
    
    return self;
}

// encodeWithCoder is called when we attempt to archive an object
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.itemTitle forKey:@"itemTitle"];
    [coder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [coder encodeBool:self.completed forKey:@"completed"];
}

@end

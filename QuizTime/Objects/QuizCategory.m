//
//  QuizCategory.m
//  SlideTest
//
//  Created by Harshit on 12/29/13.
//  Copyright (c) 2013 iGEEK. All rights reserved.
//

#import "QuizCategory.h"

@implementation QuizCategory
@synthesize categoryId,categoryName,fallsUnder;

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:self.categoryId forKey:@"categoryId"];
    [coder encodeObject:self.categoryName forKey:@"categoryName"];
    [coder encodeObject:self.fallsUnder forKey:@"fallsUnder"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.categoryId = [aDecoder decodeObjectForKey:@"categoryId"];
        self.categoryName = [aDecoder decodeObjectForKey:@"categoryName"];
        self.fallsUnder = [aDecoder decodeObjectForKey:@"fallsUnder"];
        
    }
    return self;
}
@end
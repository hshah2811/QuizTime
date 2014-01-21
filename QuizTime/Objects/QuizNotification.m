//
//  QuizNotification.m
//  SlideTest
//
//  Created by Harshit on 12/28/13.
//  Copyright (c) 2013 iGEEK. All rights reserved.
//

#import "QuizNotification.h"

@implementation QuizNotification
@synthesize notificationID,quizCategory,isActivated,notificationTime,numberOfQuestions;

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:self.notificationID forKey:@"notificationID"];
    [coder encodeObject:self.quizCategory forKey:@"quizCategory"];
    [coder encodeObject:self.isActivated forKey:@"isActivated"];
    [coder encodeObject:self.notificationTime forKey:@"notificationTime"];
    [coder encodeObject:self.numberOfQuestions forKey:@"numberOfQuestions"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.notificationID = [aDecoder decodeObjectForKey:@"notificationID"];
        self.quizCategory = [aDecoder decodeObjectForKey:@"quizCategory"];
        self.isActivated = [aDecoder decodeObjectForKey:@"isActivated"];
        self.notificationTime = [aDecoder decodeObjectForKey:@"notificationTime"];
        self.numberOfQuestions = [aDecoder decodeObjectForKey:@"numberOfQuestions"];
    }
    return self;
}
@end

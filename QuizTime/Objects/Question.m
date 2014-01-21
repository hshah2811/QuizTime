//
//  Question.m
//  QuizTime
//
//  Created by Harshit on 11/26/13.
//  Copyright (c) 2013 iGEEK. All rights reserved.
//

#import "Question.h"
#import "QuestionSetManager.h"
@implementation Question
@synthesize qID,qContent,option1,option2,option3,option4,status,category,correctAnswer;

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:self.qID forKey:@"qID"];
    [coder encodeObject:self.qContent forKey:@"qContent"];
    [coder encodeObject:self.option1 forKey:@"option1"];
    [coder encodeObject:self.option2 forKey:@"option2"];
    [coder encodeObject:self.option3 forKey:@"option3"];
    [coder encodeObject:self.option4 forKey:@"option4"];
    [coder encodeObject:self.status forKey:@"status"];
    [coder encodeObject:self.category forKey:@"category"];
    [coder encodeObject:self.correctAnswer forKey:@"correctAnswer"];
    
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.qID = [aDecoder decodeObjectForKey:@"qID"];
        self.qContent = [aDecoder decodeObjectForKey:@"qContent"];
        self.option1 = [aDecoder decodeObjectForKey:@"option1"];
        self.option2 = [aDecoder decodeObjectForKey:@"option2"];
        self.option3 = [aDecoder decodeObjectForKey:@"option3"];
        self.option4 =[aDecoder decodeObjectForKey:@"option4"];
        self.status =[aDecoder decodeObjectForKey:@"status"];
        self.category =[aDecoder decodeObjectForKey:@"category"];
        self.correctAnswer =[aDecoder decodeObjectForKey:@"correctAnswer"];
    }
    return self;
}
-(void)markAsAttempted:(NSString*)selectedOption isCorrectAnswer:(BOOL)isCorrect
{
    if (isCorrect)
    {
        self.status = Q_STATUS_CORRECT;
    }
    else
    {
        self.status = Q_STATUS_WRONG;
    }
    [self updateQuestionStatus];
}
-(void)updateQuestionStatus
{
    QuestionSetManager *manager = [QuestionSetManager new];
    manager.qCategory = self.category;
    [manager updateQuestionStatus:self];

}
-(void)markAsSkipped
{
    self.status = Q_STATUS_SKIPPED;
    [self updateQuestionStatus];
}
-(BOOL)isValidAnwer:(NSString*)selectedOption
{
   if([self.correctAnswer isEqualToString:selectedOption])
   {
       return TRUE;
   }
   else
   {
        return FALSE;
   }
}

@end

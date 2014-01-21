//
//  Question.h
//  QuizTime
//
//  Created by Harshit on 11/26/13.
//  Copyright (c) 2013 iGEEK. All rights reserved.
//

#import <Foundation/Foundation.h>
#define Q_STATUS_CORRECT @"CORRECT"
#define Q_STATUS_WRONG @"WRONG"
#define Q_STATUS_PENDING @"PENDING"
#define Q_STATUS_SKIPPED @"SKIPPED"

#define Q_CATEGORY_SAT @"SAT"
#define Q_CATEGORY_GK @"GK"
#define Q_CATEGORY_TECHNO @"TECHNO"

@interface Question :NSObject <NSCoding>
{
    NSString *qID;
    NSString *qContent;
    NSString *option1;
    NSString *option2;
    NSString *option3;
    NSString *option4;
    NSString *status;
    NSString *category;
    NSString *correctAnswer;
}
@property (retain,readwrite) NSString *qID;
@property (retain,readwrite)  NSString *qContent;
@property (retain,readwrite)  NSString *option1;
@property (retain,readwrite)  NSString *option2;
@property (retain,readwrite)  NSString *option3;
@property (retain,readwrite)  NSString *option4;
@property (retain,readwrite)  NSString *status;
@property (retain,readwrite)  NSString *category;
@property (retain,readwrite)  NSString *correctAnswer;
-(void)markAsAttempted:(NSString*)selectedOption isCorrectAnswer:(BOOL)isCorrect;
-(BOOL)isValidAnwer:(NSString*)selectedOption;
-(void)updateQuestionStatus;
-(void)markAsSkipped;
@end

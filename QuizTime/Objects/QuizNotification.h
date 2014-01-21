//
//  QuizNotification.h
//  SlideTest
//
//  Created by Harshit on 12/28/13.
//  Copyright (c) 2013 iGEEK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuizNotification :NSObject <NSCoding>
{
    NSString *notificationID;
    NSString *quizCategory;
    NSString *isActivated;
    NSDate *notificationTime;
    NSString *numberOfQuestions;
}
@property (retain,readwrite) NSString *notificationID;
@property (retain,readwrite)  NSString *quizCategory;
@property (retain,readwrite)  NSString *isActivated;
@property (retain,readwrite)  NSDate *notificationTime;
@property (retain,readwrite)  NSString *numberOfQuestions;
@end
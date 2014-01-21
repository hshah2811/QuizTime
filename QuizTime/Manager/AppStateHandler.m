//
//  AppStateHandler.m
//  SlideTest
//
//  Created by Harshit on 12/29/13.
//  Copyright (c) 2013 iGEEK. All rights reserved.
//

#import "AppStateHandler.h"
#import "ProjectConstants.h"
#import "QuizCategory.h"
#import "QuizCategoryManager.h"
@implementation AppStateHandler
+(void)loadDataFromPlistIfRequired;
{
    @autoreleasepool
    {
         QuizCategoryManager *manager = [QuizCategoryManager new];
        NSMutableArray *categories = [manager getAllCategories];
        if(categories.count == 0)
        {
            [AppStateHandler loadQuizCategories];
            [AppStateHandler loadQuizQuestions];
        }
    }
}
+(void)loadQuizCategories
{
    NSString *fileName = [NSString stringWithFormat:@"QUIZ_CATEGORY"];
    NSString *pListPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    
    // Build the array from the plist
    NSMutableDictionary *questionDetails = [[NSMutableDictionary alloc] initWithContentsOfFile:pListPath];
    NSArray *questionSet = [questionDetails objectForKey:@"categories"];
    QuizCategoryManager *manager = [QuizCategoryManager new];
    for (int i=0; i<questionSet.count; i++)
    {
        NSDictionary *productDetail = [questionSet objectAtIndex:i];
        QuizCategory *category = [[QuizCategory alloc] init];
        category.categoryId = [productDetail objectForKey:@"categoryId"];
        category.categoryName = [productDetail objectForKey:@"categoryName"];
        category.fallsUnder = [productDetail objectForKey:@"fallsUnder"];
        [manager addCategory:category];
    }
}
+(void)loadQuizQuestions
{
     QuizCategoryManager *manager = [QuizCategoryManager new];
    QuestionSetManager *setManager = [QuestionSetManager new];
    NSMutableArray *categories = [manager getAllCategories];
    for (QuizCategory *category in categories) {
        NSString *fileName = [NSString stringWithFormat:@"%@_QUESTION_SET",category.categoryId];
        NSString *pListPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
        
        if (pListPath)
        {
            NSMutableDictionary *questionDetails = [[NSMutableDictionary alloc] initWithContentsOfFile:pListPath];
            NSArray *questionSet = [questionDetails objectForKey:@"question_set"];
            BOOL tableCreated = FALSE;
            setManager.qCategory= category.categoryId;
            for (int i=0; i<questionSet.count; i++)
            {
                if (tableCreated == FALSE)
                {
                    [setManager creteTable];
                    tableCreated  = TRUE;
                }
                NSDictionary *productDetail = [questionSet objectAtIndex:i];
                Question *question = [[Question alloc] init];
                question.qID = [productDetail objectForKey:@"qID"];
                question.qContent = [productDetail objectForKey:@"qContent"];
                question.option1 = [productDetail objectForKey:@"option1"];
                question.option2 = [productDetail objectForKey:@"option2"];
                question.option3 = [productDetail objectForKey:@"option3"];
                question.option4 = [productDetail objectForKey:@"option4"];
                question.status = Q_STATUS_PENDING;
                question.category = category.categoryId;
                question.correctAnswer = [productDetail objectForKey:@"correctAnswer"];
                [setManager addQuestionToDb:question];
                }
        }
    }
    
}
@end

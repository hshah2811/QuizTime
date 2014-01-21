//
//  QuestionSetManager.h
//  SlideTest
//
//  Created by Harshit on 12/18/13.
//  Copyright (c) 2013 iGEEK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseManager.h"
#import "Question.h"

@interface QuestionSetManager : NSObject
{
   
    DatabaseManager *dbManager;
}
@property(strong,readwrite) NSString *qCategory;
-(NSMutableArray*)getQuestionsByStatus:(NSString*)status;
-(int) getQuestionCountByStatus:(NSString*)status;
-(void)updateQuestionStatus:(Question*)question_;
-(void)addQuestionToDb:(Question*)question_;
-(void) creteTable;
@end

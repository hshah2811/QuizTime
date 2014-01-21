//
//  QuestionSetManager.m
//  SlideTest
//
//  Created by Harshit on 12/18/13.
//  Copyright (c) 2013 iGEEK. All rights reserved.
//

#import "QuestionSetManager.h"

@implementation QuestionSetManager
@synthesize qCategory;
-(id)init
{
    if (self = [super init])
    {
        dbManager = [DatabaseManager getDatabaseManager];
    }
    return self;
}
-(void) creteTable
{
    NSString *createTableQuery = [NSString stringWithFormat:@"create table if not exists %@ (id TEXT PRIMARY KEY DEFAULT NULL, question BLOB, category TEXT, status TEXT);",self.qCategory];
    [dbManager executeUpdateQuery:createTableQuery];
}
-(void)addQuestionToDb:(Question*)question_
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:question_];
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO %@ VALUES (?,?,?,?)",question_.category];
    [dbManager executeUpdateQuery:insertQuery withArgumetns:@[question_.qID,data,question_.category,question_.status]];

}
-(NSMutableArray*)getQuestionsByStatus:(NSString*)status
{
    NSString *selectQuery = nil;
    FMResultSet *resultSet = nil;
    if (status) {
        selectQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE status = ?",self.qCategory];
        resultSet =[dbManager executeDbQuery:selectQuery withArgumetns:@[status]];
    }
    else
    {
        selectQuery = [NSString stringWithFormat:@"SELECT * FROM %@",self.qCategory];
        resultSet =[dbManager executeDbQuery:selectQuery withArgumetns:nil];
    }
   
    NSMutableArray *questions = [NSMutableArray array];
    while([resultSet next])
    {
        NSData *archivedData = [resultSet objectForColumnName:@"question"];
        Question *questionInDb = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
        if(questionInDb)
        {
            [questions addObject:questionInDb];
        }
    }
    return questions;
}
-(int) getQuestionCountByStatus:(NSString*)status
{
    //TODO: Use count * query.
    NSString *selectQuery = nil;
    FMResultSet *resultSet = nil;
    if (status) {
        selectQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE status = ?",qCategory];
        resultSet = [dbManager executeDbQuery:selectQuery withArgumetns:@[status]];
    }
    else
    {
        selectQuery = [NSString stringWithFormat:@"SELECT * FROM %@",qCategory];
        resultSet = [dbManager executeDbQuery:selectQuery withArgumetns:nil];
    }
   
    int count = 0;
    if (resultSet)
    {
        while([resultSet next])
        {
            count++;
        }
    }
    return count;
}
-(void)updateQuestionStatus:(Question*)question_
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:question_];
    
    NSString *updateQuery = [NSString stringWithFormat:@"UPDATE %@ set question = ?,status = ? WHERE id = ?",question_.category];
    [dbManager executeUpdateQuery:updateQuery withArgumetns:@[data,question_.status,question_.qID]];
}
//-(void)dealloc
//{
//    if (qCategory) {
//        qCategory = nil;
//    }
//}

@end

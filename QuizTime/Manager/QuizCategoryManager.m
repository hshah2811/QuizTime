//
//  QuizCategoryManager.m
//  SlideTest
//
//  Created by Harshit on 12/29/13.
//  Copyright (c) 2013 iGEEK. All rights reserved.
//

#import "QuizCategoryManager.h"
#define Q_CATEGORY_TABLE @"QUIZ_CATEGORY"
@implementation QuizCategoryManager
-(id)init
{
    
    if (self = [super init])
    {
        dbManager = [DatabaseManager getDatabaseManager];
    }
    return self;
}
-(NSMutableArray*)getAllCategories
{
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM %@",Q_CATEGORY_TABLE];
    FMResultSet *resultSet =[dbManager executeDbQuery:selectQuery withArgumetns:nil];
    NSMutableArray *cateogries = [NSMutableArray array];
    while([resultSet next])
    {
        NSData *archivedData = [resultSet objectForColumnName:@"category"];
        QuizCategory *category = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
        if(category)
        {
            [cateogries addObject:category];
        }
    }
    return cateogries;
}
-(void)removeCategory:(NSString*)categoryId
{
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = ?",Q_CATEGORY_TABLE];
    [dbManager executeUpdateQuery:deleteQuery withArgumetns:@[categoryId]];

    
}
-(void)addCategory:(QuizCategory*)category
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:category];
    
    NSString *createTableQuery = [NSString stringWithFormat:@"create table if not exists %@ (id TEXT PRIMARY KEY DEFAULT NULL, category BLOB);",Q_CATEGORY_TABLE];
    [dbManager executeUpdateQuery:createTableQuery];
    
    
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO %@ VALUES (?,?)",Q_CATEGORY_TABLE];
    [dbManager executeUpdateQuery:insertQuery withArgumetns:@[category.categoryId,data]];
}

-(QuizCategory*)getCategoryById:(NSString*)categoryId
{
    //TODO: Use count * query.
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE id = ?",Q_CATEGORY_TABLE];
    FMResultSet *resultSet = [dbManager executeDbQuery:selectQuery withArgumetns:@[categoryId]];
    QuizCategory *category = nil;
    while([resultSet next])
    {
        NSData *archivedData = [resultSet objectForColumnName:@"category"];
        category = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
        break;
    }
    return category;
}
@end

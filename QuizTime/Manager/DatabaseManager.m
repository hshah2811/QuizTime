//
//  DatabaseManager.m
//  Shopping
//
//  Created by Harshit on 7/3/13.
//
//

#import "DatabaseManager.h"

@implementation DatabaseManager
@synthesize database;
+ (DatabaseManager*)getDatabaseManager {
    static DatabaseManager *databaseManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        databaseManager = [[self alloc] init];
    });
    return databaseManager;
}
- (id)init {
    if (self = [super init])
    {
        NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *dbPath   = [docsPath stringByAppendingPathComponent:@"quiz.db"];
        self.database     = [FMDatabase databaseWithPath:dbPath];
        
        if (![self.database open])
        {
            NSLog(@"Error in setting up DB.");
          //NSString *erroMessage =   [self.database lastErrorMessage];
            //[self.database release];
        }
      
    }
    return self;
}
- (FMResultSet*)executeDbQuery:(NSString*)sqlQuery withArgumetns:(NSArray*)arguments;
{
    FMResultSet *resultSet =  [self.database executeQuery:sqlQuery withArgumentsInArray:arguments];
    return resultSet;
    
}

- (BOOL)executeUpdateQuery:(NSString*)sqlQuery withArgumetns:(NSArray*)arguments
{
    BOOL result = [self.database executeUpdate:sqlQuery withArgumentsInArray:arguments];
    return result;
}
- (BOOL)executeUpdateQuery:(NSString*)sqlQuery, ...
{
    va_list args;
    va_start(args, sqlQuery);
    
        BOOL result = [self.database executeUpdate:sqlQuery,args];
//    BOOL result = [self.database executeUpdate:sqlQuery error:nil withArgumentsInArray:nil orDictionary:nil orVAList:args];
    
    va_end(args);
    return result;
}

@end

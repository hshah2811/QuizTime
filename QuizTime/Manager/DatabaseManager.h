//
//  DatabaseManager.h
//  Shopping
//
//  Created by Harshit on 7/3/13.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface DatabaseManager : NSObject
{
    FMDatabase *database;
}
@property (retain,readwrite)FMDatabase *database;
+ (DatabaseManager*)getDatabaseManager;



- (BOOL)executeUpdateQuery:(NSString*)sqlQuery withArgumetns:(NSArray*)arguments;
- (FMResultSet*)executeDbQuery:(NSString*)sqlQuery withArgumetns:(NSArray*)arguments;
- (BOOL)executeUpdateQuery:(NSString*)sqlQuery, ...;
@end

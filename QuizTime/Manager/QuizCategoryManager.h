//
//  QuizCategoryManager.h
//  SlideTest
//
//  Created by Harshit on 12/29/13.
//  Copyright (c) 2013 iGEEK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseManager.h"
#import "QuizCategory.h"
@interface QuizCategoryManager : NSObject
{
    DatabaseManager *dbManager;
}
-(NSMutableArray*)getAllCategories;
-(void)removeCategory:(NSString*)categoryId;
-(void)addCategory:(QuizCategory*)category;
-(QuizCategory*)getCategoryById:(NSString*)categoryId;
@end

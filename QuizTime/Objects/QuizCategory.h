//
//  QuizCategory.h
//  SlideTest
//
//  Created by Harshit on 12/29/13.
//  Copyright (c) 2013 iGEEK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuizCategory : NSObject
{
    NSString *categoryId;
    NSString *categoryName;
    NSString *fallsUnder;
}
@property (retain,readwrite) NSString *categoryId;
@property (retain,readwrite)  NSString *categoryName;
@property (retain,readwrite)  NSString *fallsUnder;
@end